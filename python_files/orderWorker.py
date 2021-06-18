import datetime
import json
import time

import requests
from PySide2.QtCore import QUrl, QObject
from PySide2.QtGui import QDesktopServices

from .orderClass import OrderClass


class OrderRequestObject(QObject):

    debug = True

    def __init__(self, token, servers, captcha, signals, user):
        QObject.__init__(self)
        self.servers = servers
        self.token = token
        self.captcha = captcha
        self.user = user

        self.orders = []
        self.active_orders = []
        self.completed_orders = []

        self.signals = signals

    def load_matches(self, order_id_str):
        if order_id_str in self.active_orders:
            orders = self.active_orders
        if order_id_str in self.completed_orders:
            orders = self.completed_orders
        for order in orders:
            if order == order_id_str:
                order.get_matches(self.token)

    def load_profile_info(self):
        headers = {'Authorization': 'Bearer ' + self.token,
                   'Content-Type': 'application/json',
                   'Accept': 'application/json, text/plain, */*'
                   }

        non_json = {
            'sanitized_name': self.user['sanitized_name']
        }
        data = json.dumps(non_json)

        result = requests.post('https://api.boostroyal.com/user/getProfile', headers=headers, data=data)
        if not result.ok:
            print('Page status: ' + str(result.status_code))
            return

        # for i in result.json():
        #     if i == 'Employee':
        #         print(i)
        #         for j in result.json()[i]:
        #             print(' ' * 4, j, result.json()[i][j])
        #     else:
        #         print(i, result.json()[i])

        self.user['employee_id'] = result.json()['Employee']['id']

        non_json = {
            'id': self.user['employee_id']
        }
        data = json.dumps(non_json)

        result = requests.post('https://api.boostroyal.com/employee/getPayout', headers=headers, data=data)

        if not result.ok:
            print('Page status: ' + str(result.status_code))
            print(result.reason)
            print(result.headers)
            return

        print(result.text)

        # for i in result.json()['Matches']:
        #     print(i)
        # print()
        for i in result.json()['Orders']:
            print(i)

    def load_messages(self, order_id_str):
        if order_id_str in self.active_orders:
            orders = self.active_orders
        if order_id_str in self.completed_orders:
            orders = self.completed_orders
        for order in orders:
            if order == order_id_str:
                order.get_order_messages(self.token, self.user)

    def load_orders_from_file(self):
        headers = {'Authorization': 'Bearer ' + self.token}
        result = requests.post('https://api.boostroyal.com/order/getPendingOrders', headers=headers)
        if not result.ok:
            print('Page status: ' + str(result.status_code))
            return

        fresh_orders = self.insert_orders_into_class(data=result.json(),
                                                     servers=self.servers,
                                                     signal=self.signals.newOrderSignal,
                                                     info_signal=self.signals.orderInfoSignal,
                                                     message_signal=self.signals.messageSignal,
                                                     user_share_percent=self.user['share_percent'],
                                                     match_history_signal=self.signals.matchHistorySignal
                                                     )

        try:
            with open('saved_orders.json') as json_file:
                saved_orders_json = json.load(json_file)

                saved_orders = self.insert_orders_into_class(data=saved_orders_json,
                                                             signal=self.signals.newOrderSignal,
                                                             info_signal=self.signals.orderInfoSignal,
                                                             message_signal=self.signals.messageSignal,
                                                             servers=self.servers,
                                                             user_share_percent=self.user['share_percent'],
                                                             match_history_signal = self.signals.matchHistorySignal
                                                             )

                orders_to_add = [order for order in fresh_orders if order not in saved_orders]  # order to add
                orders_to_rem = [order for order in saved_orders if order not in fresh_orders]  # order to remove

                if orders_to_rem:
                    for order_to_delete in orders_to_rem:
                        for order in saved_orders:
                            if order == order_to_delete:
                                saved_orders.remove(order)

                for order in saved_orders:
                    order.data['new_order'] = False
                    order.emit()
                for order in orders_to_add:
                    order.data['new_order'] = True
                    order.emit()
                self.orders = fresh_orders

        except Exception as ex:
            print('Error: ', ex)

    def load_orders(self):
        headers = {'Authorization': 'Bearer ' + self.token}
        result = requests.post('https://api.boostroyal.com/order/getPendingOrders', headers=headers)
        if not result.ok:
            print('Page status: ' + str(result.status_code))
            return

        fresh_orders = self.insert_orders_into_class(data=result.json(),
                                                     servers=self.servers,
                                                     signal=self.signals.newOrderSignal,
                                                     info_signal=self.signals.orderInfoSignal,
                                                     message_signal=self.signals.messageSignal,
                                                     user_share_percent=self.user['share_percent'],
                                                     match_history_signal=self.signals.matchHistorySignal
                                                     )

        self.orders = self.add_orders_to_window(fresh_orders, self.orders, self.delete_order)

        with open('saved_orders.json', 'w') as json_file:
            json.dump(result.json(), json_file)

    def check_lock_out_order(self, order_id):
        print(order_id == self.orders)
        print(type(order_id))
        print(type(self.orders))
        print(type(self.orders[0]))
        for order in self.orders:
            if order_id in order:
                self.load_orders
        for order in self.active_orders:
            if order_id in order:
                self.load_active_orders

    def get_order_info(self, order_id, order_type):
        if order_type == 'completed_orders':
            orders = self.completed_orders
        elif order_type == 'active_orders':
            orders = self.active_orders
        for order in orders:
            if order == order_id:
                result = order.get_order_info(self.token, self.user)
                self.signals.orderInfoSignal.emit(order_type, result)

    def add_order_games(self, order_id, order_type):
        if order_type == 'completed_orders':
            orders = self.completed_orders
        elif order_type == 'active_orders':
            orders = self.active_orders
        for order in orders:
            if order == order_id:
                result = order.add_games(self.token)
                if result:
                    data = {
                        'type': 'success',
                        'info': 'Info on order {}'.format(order_id),
                        'message': 'Added games',
                        'time': self.get_current_time()
                    }
                else:
                    data = {
                        'type': 'danger',
                        'info': 'Info on order {}'.format(order_id),
                        'message': 'Games add error',
                        'time': self.get_current_time()
                    }
                self.signals.socketSignal.emit(data)

    def add_order_games_without_info(self, order_id, order_type):
        if order_type == 'completed_orders':
            orders = self.completed_orders
        elif order_type == 'active_orders':
            orders = self.active_orders
        for order in orders:
            if order == order_id:
                result = order.add_games(self.token, response=False)
                data = {
                    'type': 'info',
                    'info': 'info',
                    'message': result.text,
                    'time': self.get_current_time()
                }
                # print(result.text)
                self.socketSignal.emit(data)

    def close_continue_order(self, order_id, order_type):
        if order_type == 'completed_orders':
            orders = self.completed_orders
        elif order_type == 'active_orders':
            orders = self.active_orders
        for order in orders:
            if order == order_id:
                result = order.close_continue_order(self.token)
                data = {
                    'type': 'info',
                    'info': 'info',
                    'message': result.text,
                    'time': self.get_current_time()
                }
                print(result.text)
                self.signals.socketSignal.emit(data)

    def lock_out_order(self, order_id, order_type):
        if order_type == 'completed_orders':
            orders_list = self.completed_orders
        elif order_type == 'active_orders':
            orders_list = self.active_orders
        for order in orders_list:
            if order == order_id:
                result = order.lock_out(self.token)
                data = {
                    'type': 'info',
                    'info': 'info',
                    'message': result.text,
                    'time': self.get_current_time()
                }
                print(result.text)
                self.signals.socketSignal.emit(data)

    def full_lock_out_order(self, order_id, order_type):
        if order_type == 'completed_orders':
            orders_list = self.completed_orders
        elif order_type == 'active_orders':
            orders_list = self.active_orders
        for order in orders_list:
            if order == order_id:
                result = order.lock_out(self.token, response=False)
                data = {
                    'type': 'info',
                    'info': 'info',
                    'message': result.text,
                    'time': self.get_current_time()
                }
                print(result.text)
                self.signals.socketSignal.emit(data)

    def initiate_lock_in(self, order_id):
        headers = {'Authorization': 'Bearer ' + self.token,
                   'Content-Type': 'application/json',
                   'Accept': 'application/json, text/plain, */*'
                   }
        non_json = {'id': order_id}
        data = json.dumps(non_json)
        result = requests.post('https://api.boostroyal.com/order/initiateLockIn', headers=headers, data=data)
        print('Initiate lock in order ' + str(order_id) + ': ' + result.text)
        if type(result.json()) != bool:
            if result.json()['type'] == 'Winrate':
                data = {
                    'type': 'danger',
                    'info': 'Initiate lock in ' + str(order_id),
                    'message': "Winrate is too low",
                    'time': self.get_current_time()
                }
        else:
            if result.json():
                data = {
                    'type': 'success',
                    'info': 'Initiate lock in ' + str(order_id),
                    'message': 'Order lock in success',
                    'time': self.get_current_time()
                }
                self.load_orders()
                self.load_active_orders()
            else:
                data = {
                    'type': 'danger',
                    'info': 'Initiate lock in ' + str(order_id),
                    'message': 'Initiate lock in error',
                    'time': self.get_current_time()
                }
                # self.load_orders()
        self.signals.socketSignal.emit(data)
        return result.text

    def lock_in_order_func(self, order_id):
        headers = {'Authorization': 'Bearer ' + self.token,
                   'Content-Type': 'application/json',
                   'Accept': 'application/json, text/plain, */*'
                   }
        non_json = {'id': order_id,
                    'captcha': self.captcha}
        data = json.dumps(non_json)
        result = requests.post('https://api.boostroyal.com/order/lockIn', headers=headers, data=data)
        print('Lock in order ' + str(order_id) + ': ' + result.text)
        curr_time = self.get_current_time()

        if type(result.json()) != bool:
            if result.json()['type'] == 'Rank':
                data = {
                    'type': 'danger',
                    'info': 'Lock in',
                    'message': 'Rank is too high',
                    'time': curr_time
                }
            elif result.json()['type'] == 'DuoQ':
                data = {
                    'type': 'danger',
                    'info': 'Lock in',
                    'message': 'DuoQ timer',
                    'time': curr_time
                }
            elif result.json()['type'] == 'Server':
                data = {
                    'type': 'danger',
                    'info': 'Lock in',
                    'message': "Can't lock on this server",
                    'time': curr_time
                }
            else:
                data = {
                    'type': 'danger',
                    'info': 'Lock in',
                    'message': result.json()['type'],
                    'time': curr_time
                }
        else:
            if result.json():
                data = {
                    'type': 'success',
                    'info': 'Lock in',
                    'message': 'Order locked in',
                    'time': curr_time
                }
                self.load_active_orders()
            else:
                data = {
                    'type': 'danger',
                    'info': 'Lock in',
                    'message': result.text,
                    'time': curr_time
                }
        self.signals.socketSignal.emit(data)
        return result.text

    def lock_in_order(self, order_id):
        print('Lock in: ' + order_id)
        res = self.initiate_lock_in(order_id)
        if res != 'true':
           return
        self.lock_in_order_func(order_id)
        self.load_orders()

    def delete_all_orders(self):
        self.orders.clear()

    def load_active_orders(self):
        headers = {'Authorization': 'Bearer ' + self.token,
                   'Accept': 'application/json, text/plain, */*',
                   'Content-Type': 'application/json',
                   }
        non_json = {
            'completeOrders': False,
            'count': 1,
            'filter': '',
            'filterColumn': 'id',
            'limit': 25,
            'offset': 0,
            'orderBy': 'id',
            'orderDir': 'desc'
        }

        data = json.dumps(non_json)

        result = requests.post('https://api.boostroyal.com/order/getOrders', headers=headers, data=data)
        if not result.ok:
            print('Page status: ' + str(result.status_code))

        fresh_orders = self.insert_orders_into_class(data=result.json()['rows'],
                                                     signal=self.signals.activeOrderSignal,
                                                     info_signal=self.signals.orderInfoSignal,
                                                     message_signal=self.signals.messageSignal,
                                                     servers=self.servers,
                                                     user_share_percent=self.user['share_percent'],
                                                     match_history_signal=self.signals.matchHistorySignal
                                                     )

        self.active_orders = self.add_orders_to_window(fresh_orders,
                                                       self.active_orders,
                                                       self.delete_active_order)

    def load_completed_orders(self):
        headers = {'Authorization': 'Bearer ' + self.token,
                   'Accept': 'application/json, text/plain, */*',
                   'Content-Type': 'application/json',
                   }
        non_json = {
            'completeOrders': True,
            'count': 1,
            'filter': '',
            'filterColumn': 'id',
            'limit': 100,
            'offset': 0,
            'orderBy': 'id',
            'orderDir': 'desc'
        }

        data = json.dumps(non_json)

        result = requests.post('https://api.boostroyal.com/order/getOrders', headers=headers, data=data)
        if not result.ok:
            print('Page status: ' + str(result.status_code))

        fresh_orders = self.insert_orders_into_class(data=result.json()['rows'][::-1],
                                                     signal=self.signals.completedOrderSignal,
                                                     info_signal=self.signals.orderInfoSignal,
                                                     message_signal=self.signals.messageSignal,
                                                     servers=self.servers,
                                                     user_share_percent=self.user['share_percent'],
                                                     match_history_signal=self.signals.matchHistorySignal
                                                     )

        self.completed_orders = self.add_orders_to_window(fresh_orders,
                                                          self.completed_orders,
                                                          self.delete_completed_order)

    @staticmethod
    def add_orders_to_window(fresh_orders, order_list, delete_func):
        orders_to_add = [order for order in fresh_orders if order not in order_list]  # order to add
        orders_to_rem = [order for order in order_list if order not in fresh_orders]  # order to remove

        if orders_to_rem:
            for order_to_delete in orders_to_rem:
                delete_func(order_to_delete.data['id'])
        if orders_to_add:
            for order in orders_to_add:
                order.data['new_order'] = True
                order.emit()
        return order_list + orders_to_add

    @staticmethod
    def insert_orders_into_class(data,
                                 signal,
                                 info_signal,
                                 message_signal,
                                 servers,
                                 user_share_percent,
                                 match_history_signal):
        fresh_orders = []
        for order in data:
            new_order = OrderClass(data=order,
                                   signal=signal,
                                   info_signal=info_signal,
                                   message_signal=message_signal,
                                   servers=servers,
                                   user_share_percent=user_share_percent,
                                   match_history_signal=match_history_signal)
            fresh_orders.append(new_order)
        return fresh_orders

    @staticmethod
    def get_current_time():
        return datetime.datetime.fromtimestamp(time.time()).strftime('%H:%M:%S')

    def delete_order(self, order_id):
        for order in self.orders:
            if order.data['id'] == order_id:
                self.orders.remove(order)
                self.signals.removeOrderSignal.emit(order_id)

    def delete_completed_order(self, order_id):
        for order in self.completed_orders:
            if order.data['id'] == order_id:
                self.completed_orders.remove(order)
                self.signals.removeCompletedOrderSignal.emit(order_id)

    def delete_active_order(self, order_id):
        for order in self.active_orders:
            if order.data['id'] == order_id:
                self.active_orders.remove(order)
                self.signals.removeActiveOrderSignal.emit(order_id)

    def open_summoner_op_gg(self, nickname, server):
        if server == self.servers[1][0]:
            QDesktopServices.openUrl(QUrl('https://na.op.gg/summoner/userName=' + nickname))
        elif server == self.servers[2][0]:
            QDesktopServices.openUrl(QUrl('https://euw.op.gg/summoner/userName=' + nickname))
        elif server == self.servers[3][0]:
            QDesktopServices.openUrl(QUrl('https://eune.op.gg/summoner/userName=' + nickname))
        elif server == self.servers[10][0]:
            QDesktopServices.openUrl(QUrl('https://www.op.gg/summoner/userName=' + nickname))
        elif server == self.servers[5][0]:
            QDesktopServices.openUrl(QUrl('https://ru.op.gg//summoner/userName=' + nickname))


