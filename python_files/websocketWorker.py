import asyncio
import datetime
import json
import time

import requests
import websockets
from PySide2.QtCore import QThread


service_type = {
    1:  {'name': 'League Boosting',                     'service': "league-boosting",            'game': 'lol'},
    2:  {'name': 'Ranked Win boosting',                 'service': "ranked-wins-boost",          'game': 'lol'},
    3:  {'name': 'DuoQueue Division Boosting',          'service': "duo-queue-boosting",         'game': 'lol'},
    4:  {'name': 'DuoQueue Game Boosting',              'service': "duo-queue-boosting",         'game': 'lol'},
    5:  {'name': 'DuoQueue Win boosting',               'service': "duo-queue-boosting",         'game': 'lol'},
    6:  {'name': 'Placement Matches',                   'service': "placement-matches",          'game': 'lol'},
    7:  {'name': 'Placement Matches DuoQueue Boosting', 'service': "placement-matches",          'game': 'lol'},
    8:  {'name': 'Normal Matches',                      'service': "normal-matches",             'game': 'lol'},
    9:  {'name': 'Normal Wins',                         'service': "normal-matches",             'game': 'lol'},
    10: {'name': 'Promotion Boosting',                  'service': "promotion-boosting",         'game': 'lol'},
    11: {'name': 'Champion Mastery Boosting',           'service': "champion-mastery",           'game': 'lol'},
    12: {'name': 'Smurf account',                       'service': "smurf-account",              'game': 'lol'},
    13: {'name': 'League of Legends Account',           'service': "account-market",             'game': 'lol'},
    14: {'name': 'Guides',                              'service': "guides",                     'game': 'lol'},
    15: {'name': 'Coaching',                            'service': "coaching",                   'game': 'lol'},
    16: {'name': 'Account leveling',                    'service': "account-leveling",           'game': 'lol'},
    17: {'name': 'Clash boosting',                      'service': "clash-boosting",             'game': 'lol'},
    18: {'name': 'TFT Division Boosting',               'service': "tft-boosting",               'game': 'tft'},
    19: {'name': 'TFT Win Boosting',                    'service': "tft-boosting",               'game': 'tft'},
    20: {'name': 'TFT Placement Matches',               'service': "tft-boosting",               'game': 'tft'},
    21: {'name': 'LOR Division Boosting',               'service': "lor-boosting",               'game': 'lor'},
    22: {'name': 'LOR Win Boosting',                    'service': "lor-boosting",               'game': 'lor'},
    23: {'name': 'LOR Expedition Boosting',             'service': "lor-boosting",               'game': 'lor'},
    24: {'name': 'Eternals Boosting',                   'service': "eternals-boosting",          'game': 'lol'},
    25: {'name': 'Valorant Rank Boosting',              'service': "valorant-boosting",          'game': 'valorant'},
    26: {'name': 'Valorant Account',                    'service': "valorant-boosting",          'game': 'valorant'},
    27: {'name': 'Valorant Placement Matches',          'service': "valorant-placement-matches", 'game': 'valorant'},
    28: {'name': 'Valorant Competitive Wins Boost',     'service': "valorant-competitive-wins",  'game': 'valorant'},
    29: {'name': 'Valorant Unrated Matches',            'service': "valorant-unrated-matches",   'game': 'valorant'},
    30: {'name': 'Valorant Battle Pass',                'service': "valorant-battle-pass",       'game': 'valorant'},
    31: {'name': 'LOR Gauntlet Boosting',               'service': "lor-boosting",               'game': 'lor'},
    32: {'name': 'Valorant Challenges',                 'service': "valorant-boosting",          'game': 'valorant'},
    33: {'name': 'Wild Rift Division Boosting',         'service': "wild-rift-boosting",         'game': 'wildrift'},
    34: {'name': 'Wild Rift Win Boosting',              'service': "wild-rift-boosting",         'game': 'wildrift'},
    35: {'name': 'Wild Rift Placement Matches',         'service': "wild-rift-boosting",         'game': 'wildrift'},
    36: {'name': 'Wild Rift Normal Matches',            'service': "wild-rift-boosting",         'game': 'wildrift'},
    37: {'name': 'Premium Subscription',                'service': "boostroyal-premium",         'game': 'premium'},
    38: {'name': 'Wild Rift Promo Boosting',            'service': "wild-rift-boosting",         'game': 'wildrift'},
}

print_switch = {
    0: '\u2191',
    1: '\u2193',
    2: '\u2573',
    3: '\u21bb'
}

print_switch_no_unicode = {
    0: '>',
    1: '<',
    2: 'x',
    3: 'r'
}

socket_info_type = {
    0: 'debug',
    1: 'success',
    2: 'warning',
    3: 'danger',
    4: 'primary',
    5: 'message',
}


def get_curr_time():
    return datetime.datetime.fromtimestamp(time.time()).strftime('%H:%M:%S')


def print_console(case, text):
    try:
        print('{} \u2502 {} \u2502 {}'.format(print_switch[case], get_curr_time(), text))
    except UnicodeEncodeError:
        print('{} | {} | {}'.format(print_switch_no_unicode[case], get_curr_time(), text))


class NewOrderException(Exception):
    def __init__(self):
        super().__init__('New order exception')


class SocketThreadWorker(QThread):

    _debug = True
    # _message_debug = True
    _message_debug = False
    _send_messages = False

    def __init__(self, order_worker, servers, play_sound, signals):
        QThread.__init__(self)
        self._order_worker = order_worker
        self._servers = servers
        self.play_sound = play_sound
        self._signals = signals

        self._path = None
        self._event_loop = None
        self.websocket = None
        self._event_loop = None
        self.send_timer_var = True

        self.send_timer_task = None
        self.timer_task      = None
        self.listener_task   = None

    @property
    def send_timer_var(self):
        return self._send_timer_var

    @send_timer_var.setter
    def send_timer_var(self, value):
        self._send_timer_var = value

    @property
    def websocket(self):
        return self._websocket

    @websocket.setter
    def websocket(self, value):
        self._websocket = value

    @property
    def event_loop(self):
        return self._event_loop

    @event_loop.setter
    def event_loop(self, value):
        self._event_loop = value

    def run(self):
        while 1:
            try:
                self.event_loop = asyncio.new_event_loop()
                self.event_loop.run_until_complete(self.establish_socket())
                self.event_loop.run_forever()
            except asyncio.CancelledError:
                pass
            except Exception as ex:
                print_console(2, 'Error in websocket: {}'.format(ex))
            finally:
                print_console(3, 'Restaring ...')

    async def establish_socket(self):
        await self.start_socket()

    def get_path(self):
        result = requests.get('https://ws.boostroyal.com/socket.io/?EIO=3&transport=polling')
        if result.status_code == 200:
            result_text = json.loads(result.text[4:-4])
            sid = result_text['sid']
            self._path = 'wss://ws.boostroyal.com/socket.io/?EIO=3&transport=websocket&sid=' + sid
        else:
            print_console(2, 'Error in getting path. Page status: {}'.format(result.status_code))
            raise websockets.ConnectionClosedError(1006, 'First socket request error')

    async def start_socket(self):
        try:
            self.get_path()
            async with websockets.connect(self._path) as websocket:
                self.websocket = websocket

                message = '2probe'
                await self.websocket.send(message)
                self.send_debug_info(0, message)

                message = await websocket.recv()
                self.send_debug_info(1, message)

                message = '5'
                await self.websocket.send(message)
                self.send_debug_info(0, message)

                self.send_timer_task = asyncio.ensure_future(self.send_timer())
                self.timer_task      = asyncio.ensure_future(self.timer())
                self.listener_task   = asyncio.ensure_future(self.listen_messages())

                await self.send_timer_task
                await self.timer_task
                await self.listener_task

        except websockets.ConnectionClosedError as ex:
            print_console(2, 'Lost connection: {}'.format(ex))
            self.close_tasks()
            raise asyncio.CancelledError

    async def listen_messages(self):
        while 1:
            message = await self.websocket.recv()
            self.send_debug_info(1, message)
            self.analyze_message(message)

    async def send_timer(self):
        while 1:
            if self.send_timer_var:
                self.send_timer_var = False

                message = '2'
                await self.websocket.send(message)
                self.send_debug_info(0, message)

            await asyncio.sleep(0)

    async def timer(self):
        while 1:
            for i in range(25):
                await asyncio.sleep(1)
            self.send_timer_var = True

    def close_tasks(self):
        self.send_timer_task.cancel()
        self.timer_task.cancel()
        self.listener_task.cancel()
        self.send_timer_var = True

    def send_debug_info(self, case, message):
        if self._debug:
            print_console(case, message)
            if self._message_debug:
                self.send_socket_data(0, 'Debug info', message)

    def send_socket_data(self, info_type, title, message):
        data = {
            'type': socket_info_type[info_type],
            'info': title,
            'message': str(message),
            'time': get_curr_time()
        }
        self._signals.socketSignal.emit(data)

    def send_socket_message(self, order_id_str):
        new_message = 'New message on order ' + order_id_str
        self.send_socket_data(5, 'New message', new_message)
        self.play_sound()
        self._order_worker.load_messages(order_id_str)

    def send_socket_new_order(self, message_list):
        self._order_worker.load_orders()

        message = service_type[message_list[1]['service']]['name'] + \
                  '\n' + message_list[1]['purchase'] + \
                  ' ' + self._servers[message_list[1]['server']][1]
        self.send_socket_data(
            4, 'New order ' + str(message_list[1]['id']),
            message
        )
        self.play_sound()

    def send_socket_lock_in(self, order_id_str):
        self._order_worker.delete_order(order_id_str)
        self.send_socket_data(
            2, 'Lock in info',
            'Lock in order ' + order_id_str,
        )

    def send_socket_unpause(self, order_id_str):
        print('order unpaused')
        self.send_socket_data(
            4, 'Info',
            'Order Paused' + order_id_str,
        )
        self._order_worker.load_active_orders()

    def send_socket_pause(self, order_id_str):
        print('order paused')
        self.send_socket_data(
            4, 'Info',
            'Order unpaused' + order_id_str,
        )
        self._order_worker.load_active_orders()

    def analyze_message(self, message):
        if len(message) > 2:
            message_code = message[:2]
            if message_code == '42':
                message_list = json.loads(message[2:])
                if message_list[0] == 'newMessage':
                    order_id_str = str(message_list[1]['id'])
                    if (order_id_str in self._order_worker.active_orders) or (order_id_str in self._order_worker.completed_orders):
                        self.send_socket_message(order_id_str)

                elif message_list[0] == 'newOrderNotification':
                    self.send_socket_new_order(message_list)

                elif message_list[0] == 'orderNotification':
                    if message_list[1]['type'] == 'Lockout':
                        order_id_str = str(message_list[1]['id'])
                        if order_id_str in self._order_worker.active_orders:
                            print('order locked out')

                    elif message_list[1]['type'] == 'Lockin':
                        order_id_str = str(message_list[1]['id'])
                        self.send_socket_lock_in(order_id_str)

                    elif message_list[1]['type'] == 'Pause':
                        order_id_str = str(message_list[1]['id'])
                        if order_id_str in self._order_worker.active_orders:
                            self.send_socket_pause(order_id_str)

                    elif message_list[1]['type'] == 'Unpause':
                        order_id_str = str(message_list[1]['id'])
                        if order_id_str in self._order_worker.active_orders:
                            self.send_socket_unpause(order_id_str)

                elif message_list[0] == 'newNotification':
                    self._order_worker.load_orders()
                else:
                    pass

    def create_room(self, room_id):
        asyncio.new_event_loop().run_until_complete(self.create_room_async(room_id))

    async def create_room_async(self, room_id):
        message_data = ["create", room_id]
        msg = '42' + json.dumps(message_data)
        print(msg)
        await self.websocket.send(msg)
        self.send_debug_info(0, msg)
        self.send_socket_data(
            4, 'Debug info',
            str(msg),
        )

    def send_message(self, text, room_id, sender):
        asyncio.new_event_loop().run_until_complete(self.send_message_async(text, room_id, sender))

    async def send_message_async(self, text, room_id, sender):
        message_data = ["message", {"msg": text, "room": room_id, "sender": str(sender)}]
        msg = '42' + json.dumps(message_data)
        print(msg)
        await self.websocket.send(msg)
        self.send_debug_info(0, msg)
        self.send_socket_data(
            4, 'Debug info',
            str(msg),
        )


'''
class SocketThreadWorker(QThread):
    debug = True
    # message_debug = True
    message_debug = False
    send_messages = False

    def __init__(self, order_worker, servers, play_sound, signals):
        QThread.__init__(self)
        self.order_worker = order_worker
        self.servers = servers
        self.play_sound = play_sound
        self.signals = signals
        self.websocket = None

    @staticmethod
    def get_current_time():
        return datetime.datetime.fromtimestamp(time.time()).strftime('%H:%M:%S')

    def run(self):
        result = requests.get('https://ws.boostroyal.com/socket.io/?EIO=3&transport=polling')
        sid = json.loads(result.text[4:-4])['sid']
        path = 'wss://ws.boostroyal.com/socket.io/?EIO=3&transport=websocket&sid=' + sid
        asyncio.new_event_loop().run_until_complete(self.start_socket_dialog(path))

    def create_room(self, room_id):
        asyncio.new_event_loop().run_until_complete(self.create_room_async(room_id))

    async def create_room_async(self, room_id):
        message_data = ["create", room_id]
        msg = '42' + json.dumps(message_data)
        print(msg)
        await self.websocket.send(msg)

        curr_time = self.get_current_time()
        if self.debug:
            print('/\: ' + msg + ' | ' + curr_time)

        if self.message_debug:
            data = {
                'type': 'debug',
                'info': 'Debug info',
                'message': str(msg),
                'time': str(curr_time)
            }
            self.signals.socketSignal.emit(data)

    def send_message(self, text, room_id, sender):
        asyncio.new_event_loop().run_until_complete(self.send_message_async(text, room_id, sender))

    async def send_message_async(self, text, room_id, sender):
        message_data = ["message", {"msg": text, "room": room_id, "sender": str(sender)}]
        msg = '42' + json.dumps(message_data)
        print(msg)
        await self.websocket.send(msg)

        curr_time = self.get_current_time()

        if self.debug:
            print('/\: ' + msg + ' | ' + curr_time)
        if self.message_debug:
            data = {
                'type': 'debug',
                'info': 'Debug info',
                'message': str(msg),
                'time': str(curr_time)
            }
            self.signals.socketSignal.emit(data)

    async def timer(self):
        while 1:
            msg = '2'
            try:
                await self.websocket.send(msg)
            except Exception as ex:
                print('Exception raised in websocket: {}\n'.format(ex))
                data = {
                    'type': 'danger',
                    'info': 'Socket info',
                    'message': 'Exception raised: {} \n Restart application'.format(ex),
                    'time': self.get_current_time()
                }
                self.play_sound()
                self.signals.socketSignal.emit(data)
                return
            else:
                curr_time = self.get_current_time()
                if self.debug:
                    print('/\: ' + msg + ' | ' + curr_time)
                # self.analize_message(data)
                if self.message_debug:
                    data = {
                        'type': 'debug',
                        'info': 'Debug info',
                        'message': str(msg),
                        'time': str(curr_time)
                    }
                    self.signals.socketSignal.emit(data)
                await asyncio.sleep(25)

    async def listener(self):
        while 1:
            try:
                answer = await self.websocket.recv()
            except Exception as ex:
                print('Exception raised in websocket: {}\n'.format(ex))
                data = {
                    'type': 'danger',
                    'info': 'Socket info',
                    'message': 'Exception raised: {}'.format(ex),
                    'time': self.get_current_time()
                }
                self.play_sound()
                self.signals.socketSignal.emit(data)
                return
            else:
                curr_time = datetime.datetime.fromtimestamp(time.time()).strftime('%H:%M:%S')
                if self.debug:
                      print('\/: ' + answer + ' | ' + curr_time)
                data = {
                    'type': 'debug',
                    'info': 'Debug info',
                    'message': str(answer),
                    'time': (curr_time)
                }
                self.analize_message(data)
                if self.message_debug:
                    self.signals.socketSignal.emit(data)

    async def start_socket_dialog(self, path):
        async with websockets.connect(path) as websocket:
            self.websocket = websocket
            msg = '2probe'
            await websocket.send(msg)
            # curr_time = datetime.datetime.fromtimestamp(time.time()).strftime('%H:%M:%S.%f')
            curr_time = self.get_current_time()

            if self.debug:
                print('/\: ' + msg + ' | ' + curr_time)

            if self.message_debug:
                data = {
                    'type': 'debug',
                    'info': 'Debug info',
                    'message': str(msg),
                    'time': str(curr_time)
                }
                self.signals.socketSignal.emit(data)

            answer = await websocket.recv()
            curr_time = self.get_current_time()
            if self.debug:
                print('\/: ' + answer + ' | ' + curr_time)

            # self.analize_message(data)

            if self.message_debug:
                data = {
                    'type': 'debug',
                    'info': 'Debug info',
                    'message': str(answer),
                    'time': str(curr_time)
                }
                self.signals.socketSignal.emit(data)
            msg = '5'
            await websocket.send(msg)
            if self.debug:
                print('/\: ' + msg + ' | ' + curr_time)

            # self.analize_message(data)

            if self.message_debug:
                data = {
                    'type': 'debug',
                    'info': 'Debug info',
                    'message': msg,
                    'time': curr_time
                }
                self.signals.socketSignal.emit(data)
            timer_task = asyncio.create_task(self.timer())
            listener_task = asyncio.create_task(self.listener())
            while 1:
                await timer_task
                await listener_task

    def analize_message(self, packet):
        message = packet['message']
        try:
            if len(message) > 2:
                message_code = message[:2]
                if message_code == '42':
                    message_list = json.loads(message[2:])
                    if message_list[0] == 'newMessage':
                        order_id_str = str(message_list[1]['id'])
                        if (order_id_str in self.order_worker.active_orders) or (order_id_str in self.order_worker.completed_orders):
                            new_message = 'New message on order ' + order_id_str
                            data = {
                                'type': 'message',
                                'info': 'New message',
                                'message': new_message,
                                'time': packet['time']
                            }
                            self.play_sound()
                            self.signals.socketSignal.emit(data)
                            self.order_worker.load_messages(order_id_str)

                    elif message_list[0] == 'newOrderNotification':
                        self.order_worker.load_orders()
                        message = service_type[message_list[1]['service']]['name'] + \
                            '\n' + message_list[1]['purchase'] + \
                            ' ' + self.servers[message_list[1]['server']][1]
                        data = {
                            'type': 'primary',
                            'info': 'New order ' + str(message_list[1]['id']),
                            'message': message,
                            'time': packet['time']
                        }
                        self.play_sound()
                        self.signals.socketSignal.emit(data)
                    elif message_list[0] == 'orderNotification':
                        if message_list[1]['type'] == 'Lockout':
                            print('lokout')
                        elif message_list[1]['type'] == 'Lockin':
                            self.order_worker.delete_order(str(message_list[1]['id']))
                            data = {
                                'type': 'warning',
                                'info': 'Info',
                                'message': 'Lock in order ' + str(message_list[1]['id']),
                                'time': packet['time']
                            }
                            self.signals.socketSignal.emit(data)
                        elif message_list[1]['type'] == 'Pause':
                            self.order_worker.load_orders()

                    elif message_list[0] == 'newNotification':
                        self.order_worker.load_orders()
                    else:
                        pass
        except Exception as ex:
            print('Exception raised in websocket: {}'.format(ex))
            data = {
                'type': 'danger',
                'info': 'Socket info',
                'message': 'Exception raised: {}'.format(ex),
                'time': self.get_current_time()
            }
            self.signals.socketSignal.emit(data)

'''