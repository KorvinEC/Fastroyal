import json

import requests
import datetime
import shutil
import re
import os

from PySide2.QtCore import QUrl


order_status = {
    0: 'Awaiting for booster',
    1: 'Processing',
    2: 'Complete',
    3: 'Paused',
    4: 'Suspended',
    5: 'Awaiting payment',
}


def get_last_game_str(game_time):
    time = datetime.datetime.now() - game_time
    return_str = ''
    # print(time)

    days, seconds = time.days, time.seconds
    hours = days * 24 + seconds // 3600
    minutes = (seconds % 3600) // 60

    print(days, hours, minutes)

    if time <= datetime.timedelta(hours=1):
        return_str = '{} minutes ago'.format(minutes)
    elif time <= datetime.timedelta(hours=24):
        if hours > 1:
            if minutes > 30:
                return_str = '{} hours ago'.format(hours + 1)
            else:
                return_str = '{} hours ago'.format(hours)
        else:
            return_str = 'An hour ago'.format(hours)
    elif time <= datetime.timedelta(days=31):
        if hours <= 36:
            return_str = 'A day ago'
        else:
            return_str = '{} days ago'.format(days + 1)
    elif time > datetime.timedelta(days=31):
        return_str = 'a months ago'
    else:
        return_str = 'unknown'
    # print(return_str, '\n')
    return return_str


class OrderMatches:
    def __init__(self, data):
        self.data = None
        self.analyze_data(data)

    def __str__(self):
        return '{} {} {}'.format(self.data['id'], self.data['champion'], self.data['time'])

    def __eq__(self, other_id):
        return self.data['id'] == other_id

    def analyze_data(self, game):
        # print(game)
        time = datetime.datetime.fromtimestamp(game['timestamp'])
        last_time = get_last_game_str(time)

        data = {
            'id': game['id'],
            'type': game['type'],
            'time': time.strftime('%d.%m.%Y %H:%M'),
            'last_time': last_time,
            'length': game['length'],
            'result': game['result'],
            'kills': game['kills'],
            'deaths': game['deaths'],
            'assists': game['assists'],
            'ratio': '{:.2f}'.format( game['ratio']),
            'level': game['level'],
            'cs': game['cs'],
            'csps': game['csps'],
            'killParticipation': game['killParticipation'],

            'champion': game['champion'],
            'championImage': self.download_image(game['championImage']),
            'spell1': game['spell1'],
            'spell1Image': self.download_image(game['spell1Image']),
            'spell2': game['spell2'],
            'spell2Image': self.download_image(game['spell2Image'])
        }
        # print(game['items'])
        for i, item in zip(range(len(game['items'])), game['items']):
            if 'name' in item.keys():
                data['item_' + str(i) + '_image'] = self.download_image(item['image'])
            else:
                data['item_' + str(i) + '_image'] = None
        # print(data)
        self.data = data

    @staticmethod
    def download_image(image_url):
        image_url_for_download = 'https:' + image_url.split('?')[0]
        filename = re.split('[/?]', image_url)[-2]
        file_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'components', 'images', filename))
        if os.path.isfile(file_path):
            return filename
        else:
            request = requests.get(image_url_for_download, stream=True)
            if request.status_code == 200:
                request.raw.decode_content = True
                with open(file_path, 'wb') as file:
                    shutil.copyfileobj(request.raw, file)
                print('Image successfully Downloaded: ', filename)
                return filename
            else:
                print('Image could not be retrieved')
                return None


class OrderClass:

    def __init__(self,
                 data: dict,
                 servers,
                 signal,
                 info_signal,
                 message_signal,
                 user_share_percent,
                 match_history_signal,
                 ):

        self.data = self.analize_data(servers, data, user_share_percent)
        self.OrderSignal = signal
        self.OrderInfoSignal = info_signal
        self.MessageSignal = message_signal
        self.MatchHistorySignal = match_history_signal
        self.chat_info = []
        self.match_history = []

    def __str__(self):
        return self.data['id']

    def __repr__(self):
        return self.data['id']

    def __eq__(self, other_id):
        return self.data['id'] == other_id

    def emit(self):
        self.OrderSignal.emit(self.data)

    def analyze_games(self, games, send_new=False):
        if 'games' in games.keys():
            for game in games['games']:
                if game['id'] not in self.match_history:
                    match_game = OrderMatches(game)
                    self.match_history.append(match_game)
                    if send_new:
                        self.MatchHistorySignal.emit(self.data['id'], match_game)
        if not send_new:
            for game in self.match_history[::-1]:
                self.MatchHistorySignal.emit(self.data['id'], game.data)

    def get_matches(self, token):
        headers = {'Authorization': 'Bearer ' + token,
                   'Accept': 'application/json, text/plain, */*',
                   'Content-Type': 'application/json',
                   }
        non_json = {'id': self.data['id']}
        data = json.dumps(non_json)
        result = requests.get('https://api.boostroyal.com/getSummary/' + self.data['server'][1].lower() + '/' + self.data['nickname'], headers=headers, data=data)
        if result.status_code == 200:
            self.analyze_games(result.json())
        else:
            print('Server error')

    def get_order_info(self, token, user):
        headers = {'Authorization': 'Bearer ' + token,
                   'Accept': 'application/json, text/plain, */*',
                   'Content-Type': 'application/json',
                   }

        non_json = {'id': self.data['id']}
        data = json.dumps(non_json)
        result = requests.post('https://api.boostroyal.com/order/showOrder', headers=headers, data=data)

        if not result.ok:
            raise ConnectionError
        for chat_message in result.json()['Chat_messages'][::-1]:
            message_time = datetime.datetime.fromisoformat(chat_message['createdAt'].replace('Z', ''))
            time_seen = datetime.datetime.fromisoformat(chat_message['updatedAt'].replace('Z', ''))
            data = {
                'id': chat_message['id'],
                'message': chat_message['message'].rstrip().lstrip(),
                'sender': chat_message['sender'] == user['id'],
                'message_info': message_time.strftime('%d-%m-%Y %H:%M:%S') + ' | ' + ('Seen' if message_time < time_seen else 'Not seen')
            }
            if data not in self.chat_info:
                self.chat_info.append(data)
        return_data = self.data
        return_data['Chat_messages'] = self.chat_info
        return_data['nickname'] = result.json()['nickname']
        return return_data

    def add_games(self, token, response=True):
        headers = {'Authorization': 'Bearer ' + token,
                   'Accept': 'application/json, text/plain, */*',
                   'Content-Type': 'application/json',
                   }
        non_json = {
            'id': self.data['id'],
            'withData': response
        }
        data = json.dumps(non_json)
        result = requests.post('https://api.boostroyal.com/order/addGames', headers=headers, data=data)
        if result.status_code == 200:
            self.analyze_games(result.json(), send_new=True)
            return True
        else:
            return False

    def lock_out(self, token, response=True):
        headers = {'Authorization': 'Bearer ' + token,
                   'Accept': 'application/json, text/plain, */*',
                   'Content-Type': 'application/json',
                   }
        non_json = {
            'defaultCut': True,
            'id': self.data['id'],
            'priceRes': response,
            'progressPay': True
        }
        data = json.dumps(non_json)
        result = requests.post('https://api.boostroyal.com/order/lockOut', headers=headers, data=data)
        return result

    def assign_order(self, token, assign_token):
        headers = {'Authorization': 'Bearer ' + token,
                   'Accept': 'application/json, text/plain, */*',
                   'Content-Type': 'application/json',
                   }
        non_json = {
            'id': self.data['id'],
            'token': assign_token
        }
        data = json.dumps(non_json)
        result = requests.post('https://api.boostroyal.com/order/assigneOrder', headers=headers, data=data)
        return result

    def close_continue_order(self, token):
        headers = {'Authorization': 'Bearer ' + token,
                   'Accept': 'application/json, text/plain, */*',
                   'Content-Type': 'application/json',
                   }
        non_json = {'id': self.data['id']}
        data = json.dumps(non_json)
        result = requests.post('https://api.boostroyal.com/order/closeOrder', headers=headers, data=data)
        return result

    def get_order_messages(self, token, user):
        headers = {'Authorization': 'Bearer ' + token,
                   'Accept': 'application/json, text/plain, */*',
                   'Content-Type': 'application/json',
                   }
        non_json = {
            'id': self.data['id'],
            'offset': self.data['Chat_messages'][-1]['id'] if 'Chat_messages' in self.data.keys() else 0,
            'previousMsg': False
        }
        data = json.dumps(non_json)
        result = requests.post('https://api.boostroyal.com/chat_message/getOrderMessages', headers=headers, data=data)

        for chat_message in result.json():
            time = datetime.datetime.fromisoformat(chat_message['createdAt'].replace('Z', ''))
            time_seen = datetime.datetime.fromisoformat(chat_message['updatedAt'].replace('Z', ''))
            data = {
                'id': chat_message['id'],
                'message': chat_message['message'].rstrip().lstrip(),
                'sender':  chat_message['sender'] == user['id'],
                'message_info': str(time) + ' | ' + ('Seen' if time < time_seen else 'Not seen')
            }
            self.MessageSignal.emit(self.data['id'], data)
            self.chat_info.append(data)
        return result

    @staticmethod
    def analize_data(servers, data, user_share_percent):
        return_data = {}
        # import pprint
        # pprint.pprint(data)
        order_details = data['orderdetails']
        order_details_keys = order_details.keys()
        return_data['id'] = str(data['id'])
        return_data['server'] = servers[data['server']]
        return_data['purchase'] = str(data['purchase'])
        return_data['price'] = ('$' + str(round(data['price'] * (
                user_share_percent if data['share_percent'] == 0 else data['share_percent'] * 0.01), 2)))

        return_data['status'] = order_status[data['status']]

        # print(return_data['status'])

        if 'currentLp' in order_details_keys:
            return_data['currentLp'] = str(order_details['currentLp']) + ' LP'

        if 'lpGain' in order_details_keys:
            return_data['lpGain'] = str(order_details['lpGain']) + ' gain'

        if 'duoQ' in order_details_keys:
            if order_details['duoQ']:
                return_data['duoQ'] = 'DuoQ'

        if 'priorityOrder' in order_details_keys:
            if order_details['priorityOrder']:
                return_data['priorityOrder'] = 'Priority'

        if 'queue' in order_details_keys:
            return_data['queue'] = order_details['queue']

        if 'specificChampions' in order_details_keys:
            if order_details['specificChampions']:
                text = '1st: ' + order_details['specificChampions']['firstRole']['name']
                if order_details['specificChampions']['firstRole']['champions']:
                    text += ': '
                    for champ in order_details['specificChampions']['firstRole']['champions']:
                        text += champ + ' '
                else:
                    text += ' '
                text += '| 2nd: ' + order_details['specificChampions']['secondRole']['name']
                if order_details['specificChampions']['secondRole']['champions']:
                    text += ': '
                    for champ in order_details['specificChampions']['secondRole']['champions']:
                        text += champ + ' '
                return_data['specificChampions'] = text

        if 'appearOffline' in order_details_keys:
            if order_details['appearOffline']:
                return_data['appearOffline'] = 'Appear offline'

        if 'coaching' in order_details_keys:
            if order_details['coaching']:
                return_data['coaching'] = 'Coaching'

        if 'plusWin' in order_details_keys:
            if order_details['plusWin']:
                return_data['plusWin'] = '+1 net win'

        if 'rolePreference' in order_details_keys:
            if order_details['rolePreference']:
                return_data['rolePreference'] = 'Role preference: ' + str(order_details['rolePreference'])

        if 'comments' in data.keys():
            if data['comments']:
                return_data['comments'] = 'Comments: ' + str(data['comments'])

        if 'spellOrder' in order_details_keys:
            if order_details['spellOrder'] is not None:
                if order_details['spellOrder']:
                    return_data['spellOrder'] = 'Flash on F'
                else:
                    return_data['spellOrder'] = 'Flash on D'
        if 'firstOrder' in order_details_keys:
            if order_details['firstOrder']:
                return_data['firstOrder'] = 'First order'

        if 'info' in order_details_keys:
            if order_details['info']:
                return_data['info'] = 'Info: ' + order_details['info']
        if 'firstOrder' in order_details_keys:
            if order_details['firstOrder']:
                return_data['firstOrder'] = 'First order'
        if 'streaming' in order_details_keys:
            if order_details['streaming']:
                return_data['streaming'] = 'With streaming'
        if 'netGame' in order_details_keys:
            if order_details['netGame']:
                return_data['netGame'] = 'Games instead of wins'
        if 'token' in order_details_keys:
            if order_details['token']:
                return_data['token'] = 'Token needed: ' + str(order_details['token'])
        if 'masteryPoints' in order_details_keys:
            if order_details['masteryPoints']:
                return_data['masteryPoints'] = 'Mastery points: ' + str(order_details['masteryPoints'])
        if 'champion' in order_details_keys:
            if order_details['champion']:
                return_data['champion'] = order_details['champion']
        if 'points' in order_details_keys:
            if order_details['points']:
                return_data['points'] = 'From ' + str(order_details['points'][0]) + ' LP to ' + str(
                    order_details['points'][1]) + ' LP'
        # WILD RIFT
        if 'bringFriend' in order_details_keys:
            if order_details['bringFriend']:
                return_data['points'] = 'Bring friends'
        if 'marks' in order_details_keys:
            if order_details['marks']:
                return_data['marks'] = 'Marks: ' + str(order_details['marks'])
        if 'platform' in order_details_keys:
            if order_details['platform']:
                return_data['platform'] = order_details['platform']

        return return_data
