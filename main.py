# This Python file uses the following encoding: utf-8

import base64
import json
# This Python file uses the following encoding: utf-8
import os
import sys
import traceback
import hashlib
from pathlib import Path

import requests
from PySide2.QtCore import QObject, Slot, Signal, QUrl, QThreadPool, QRunnable
from PySide2.QtGui import QGuiApplication
from PySide2.QtMultimedia import QMediaContent, QMediaPlayer
from PySide2.QtQml import QQmlApplicationEngine
from PySide2 import QtOpenGL

from python_files.orderWorker import OrderRequestObject
from python_files.websocketWorker import SocketThreadWorker

# sys.path.append('/path/to/application/app/folder')

# \/: 42["orderNotification",{"type":"Lockin","id":166460,"to":null}] | 12:10:17

servers = {
     1: ['North America', 'NA'],
     2: ['Eu-west', 'EuW'],
     3: ['EU-Nordic & East', 'EuNE'],
     4: ['Turkey', 'TR'],
     5: ['Russia', 'RU'],
     6: ['Brazil', 'BR'],
     7: ['Latin America North', 'LAN'],
     8: ['Latin America South', 'LAS'],
     9: ['Oceania', 'OCE'],
    10: ['Korea', 'KR'],
    11: ['Japan', 'JP'],
    12: ['Public Beta Enviroment', 'PBE'],
    13: ['South East Asia', 'SEA'],
    14: ['China', 'CN'],
    15: ['Europe', 'EU'],
    16: ['SEA / OCE', 'SEA / OCE'],
    17: ['Mexico', 'ME'],
}


class WorkerSignals(QObject):
    finished = Signal()
    error = Signal(tuple)
    result = Signal(object)
    progress = Signal(int)


class Worker(QRunnable):
    def __init__(self, fn, *args, **kwargs):
        super(Worker, self).__init__()

        # Store constructor arguments (re-used for processing)
        self.fn = fn
        self.args = args
        self.kwargs = kwargs
        self.signals = WorkerSignals()

        # Add the callback to our kwargs
        # self.kwargs['progress_callback'] = self.signals.progress

    @Slot()
    def run(self):
        try:
            result = self.fn(*self.args, **self.kwargs)
        except:
            traceback.print_exc()
            exctype, value = sys.exc_info()[:2]
            self.signals.error.emit((exctype, value, traceback.format_exc()))
        else:
            self.signals.result.emit(result)  # Return the result of the processing
        finally:
            self.signals.finished.emit()  # Done


class SignalsClass(QObject):
    # orderSignal = Signal('QVariant')
    socketSignal = Signal('QVariant')

    newOrderSignal = Signal('QVariant')
    removeOrderSignal = Signal(str)

    completedOrderSignal = Signal('QVariant')
    removeCompletedOrderSignal = Signal(str)

    activeOrderSignal = Signal('QVariant')
    removeActiveOrderSignal = Signal(str)

    orderInfoSignal = Signal(str, 'QVariant')

    orderAddGamesSignal = Signal(str, 'QVariant')

    messageSignal = Signal(str, 'QVariant')

    loginResultSignal = Signal(str, str)

    settingsSignal = Signal(float)

    matchHistorySignal = Signal(str, 'QVariant')


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)

        self.token = ''
        self.user = None
        self.captcha = '03AGdBq24YqauF3NysTYlNgCPGmcmyQG6_YKfbLLDgTBCEeUJOaXFgeYXzMF2B0L2jU-0wIdss6T1p3HGkX5-7mBx3ZecTid02YPzV-9F6ThJUosgCeMZ4uihSAlcOUKeaRH0EO5LMzs_dI9LtCYs0MGlAlQlcE-h5YBdjrUTx7kMMEyHrsvvf4zR_hBEL1-CxHTuUzZ2GWDvmFHY2Fr7h_7TgOfX-jkZmKofDrZs4mwhmuWFiZVBis7JoLpqn0AYeQd0_K0BsUndXiiUPMqQmHE8nVzHcOq6Wjia51OWcMwDhOTNsgcTYFjjougQwchTE92K-2-le1HzQzrOwFXsJFG9e-3bSAtlS1Yv2G44w1RiCl1ICR7l2vfBLfiSlnEmlAQoczFanFc8A5ygu02x66pjUW7TL4g-1jIBsYMYN7Tmt0WGw_j4qxx0OUZ8DS3LSl0F-ohWdknmYjoETOjDXOSUVRIuxhjZdpA'
        self.player = None
        self.order_worker = None
        self.socket_worker = None
        self.thread_pool = QThreadPool()

        self.signals = SignalsClass()

        self.start_player()

        self.load_settings_from_file()


    def load_settings_from_file(self):
        try:
            with open('settings.json') as json_file:
                settings = json.load(json_file)
                self.player.setVolume(settings['sound_volume'] * 100)
                # print(self.player.volume())

                if settings['remember_me']:
                    self.login(settings['remember_me'],
                               settings['email'],
                               settings['password']
                               )

        except FileNotFoundError:
            with open('settings.json', 'w') as json_file:
                data = {
                    'sound_volume': 0.3,
                    'remember_me': False,
                    'email': None,
                    'password': None
                }
                json.dump(data, json_file)

    def start_player(self):
        self.player = QMediaPlayer()
        sound = QMediaContent(QUrl.fromLocalFile(os.path.abspath('light-562.mp3')))
        self.player.setMedia(sound)

    def start_workers(self):
        self.order_worker = OrderRequestObject(token=self.token,
                                               servers=servers,
                                               captcha=self.captcha,
                                               signals=self.signals,
                                               user=self.user)

        self.socket_worker = SocketThreadWorker(order_worker=self.order_worker,
                                                play_sound=self.play_sound,
                                                servers=servers,
                                                signals=self.signals)
        self.socket_worker.start()

    @Slot()
    def get_one_order(self):
        self.signals.newOrderSignal.emit({
            'id': 111111,
            'purchase': 'testing'
        })

    @Slot(str)
    def get_matches(self, order_id):
        worker = Worker(self.order_worker.load_matches, str(order_id))
        self.thread_pool.start(worker)

    @Slot()
    def load_settings(self):
        # print(self.player.volume(), self.player.volume() / 100)
        self.signals.settingsSignal.emit(self.player.volume() / 100)

    @Slot()
    def load_profile_info(self):
        worker = Worker(self.order_worker.load_profile_info)
        self.thread_pool.start(worker)

    @Slot(int)
    def load_messages(self, order_id):
        worker = Worker(self.order_worker.load_messages, str(order_id))
        self.thread_pool.start(worker)

    @Slot(int)
    def create_chat_room(self, order_id):
        worker = Worker(self.socket_worker.create_room, order_id)
        self.thread_pool.start(worker)

    @Slot(str, int)
    def send_message(self, text, order_id):
        worker = Worker(self.socket_worker.send_message, text, order_id, self.user['id'])
        self.thread_pool.start(worker)

    @Slot()
    def play_sound(self):
        self.player.stop()
        self.player.play()

    @Slot(float)
    def set_volume(self, value):

        self.player.setVolume(value * 100)
        with open('settings.json', 'r') as json_file:
            settings = json.load(json_file)
            settings['sound_volume'] = round(value, 2)

        with open('settings.json', 'w') as json_file:
            json.dump(settings, json_file)

    @Slot()
    def load_orders(self):
        worker = Worker(self.order_worker.load_orders)
        self.thread_pool.start(worker)

    @Slot()
    def load_orders_from_file(self):
        worker = Worker(self.order_worker.load_orders_from_file)
        self.thread_pool.start(worker)

    @Slot()
    def load_completed_orders(self):
        worker = Worker(self.order_worker.load_completed_orders)
        self.thread_pool.start(worker)

    @Slot()
    def load_active_orders(self):
        worker = Worker(self.order_worker.load_active_orders)
        self.thread_pool.start(worker)

    @Slot(str)
    def lock_in_order(self, order_id):
        print('lock in')
        worker = Worker(self.order_worker.lock_in_order, order_id)
        self.thread_pool.start(worker)

    @Slot(str)
    def delete_order(self, order_id):
        worker = Worker(self.order_worker.delete_order, order_id)
        self.thread_pool.start(worker)

    @Slot(str, str)
    def get_order_info(self, order_id, order_type):
        worker = Worker(self.order_worker.get_order_info, order_id, order_type)
        self.thread_pool.start(worker)

    @Slot(str, str)
    def add_order_games(self, order_id, order_type):
        worker = Worker(self.order_worker.add_order_games, order_id, order_type)
        self.thread_pool.start(worker)

    @Slot(str, str)
    def open_summoner_op_gg(self, nickname, server):
        worker = Worker(self.order_worker.open_summoner_op_gg, nickname, server)
        self.thread_pool.start(worker)

    @Slot(str, str)
    def close_continue_order(self, order_id, order_type):
        worker = Worker(self.order_worker.close_continue_order, order_id, order_type)
        self.thread_pool.start(worker)

    @Slot(str, str)
    def lock_out_order(self, order_id, order_type):
        worker = Worker(self.order_worker.lock_out_order, order_id, order_type)
        self.thread_pool.start(worker)

    @Slot(str, str)
    def full_lock_out_order(self, order_id, order_type):
        worker = Worker(self.order_worker.full_lock_out_order, order_id, order_type)
        self.thread_pool.start(worker)

    @Slot(bool, str, str)
    def login(self, check_box, email, password):
        worker = Worker(self.login_func, check_box, email, password)
        self.thread_pool.start(worker)

    def login_func(self, check_box, email, password):

        if check_box:
            with open('settings.json', 'r') as json_file:
                settings = json.load(json_file)
                settings['remember_me'] = True
                # print(email)
                # hash = hashlib.sha256(bytes(email, 'utf-8'))
                # dk = hashlib.pbkdf2_hmac('sha256', b'password', b'salt', 100000)
                # print(hash.hexdigest())
                # print()
                settings['email'] = email
                settings['password'] = password
            with open('settings.json', 'w') as json_file:
                json.dump(settings, json_file)

        if not self.user:
            headers = {'Content-Type': 'application/json',
                       'Accept': 'application/json, text/plain, */*'
                       }
            non_json = {'email': str(email),
                        'password': str(password)}

            data = json.dumps(non_json)
            result = requests.post('https://api.boostroyal.com/auth/login', headers=headers, data=data)
            self.signals.loginResultSignal.emit(str(result.status_code), str(result.reason))

            if result.ok:
                self.token = result.json()['token']
                token_info = self.token.split('.')[1]
                missing_padding = len(token_info) % 4
                if missing_padding:
                    token_info += '=' * (4 - missing_padding)

                val = json.loads(base64.urlsafe_b64decode(token_info))

                self.user = {}
                self.user['id'] = val['user']
                self.user['sanitized_name'] = val['sanitized_name']
                self.user['share_percent'] = val['employee']['share_percent'] / 100

                self.start_workers()
                self.signals.loginResultSignal.emit('700', 'start load')
            else:
                pass
        else:
            print('User already logged in')

    def get_user_profile(self):
        headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json, text/plain, */*',
            'Authorization': 'Bearer ' + self.token,
        }
        non_json = {
            'sanitized_name': self.user['sanitized_name']
        }
        data = json.dumps(non_json)
        result = requests.post('https://api.boostroyal.com/user/getProfile', headers=headers, data=data)

    # def get_user_info(self):
    #     headers = {
    #         'Content-Type': 'application/json',
    #         'Accept': 'application/json, text/plain, */*',
    #     }
    #     non_json = {
    #         # 'access_token': self.token
    #     }
    #     data = json.dumps(non_json)
    #     result = requests.post('https://api.boostroyal.com/user/getAllAgents', headers=headers, data=data)
    #     print(result.text)
    #     print(result.json())
    #     for item in result.json():
    #         print(item)


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)

    # app_icon = QIcon()
    # app_icon.addFile(os.path.dirname(os.path.abspath(__file__)) + '\\component\\icons\\br_grey_51x51.png')
    # app.setWindowIcon(app_icon)

    engine = QQmlApplicationEngine()

    main_window = MainWindow()

    engine.rootContext().setContextProperty('backend', main_window)
    engine.rootContext().setContextProperty('order_backend', main_window.signals)

    qml_file = os.fspath(Path(__file__).resolve().parent / 'qml/main.qml')

    engine.load(os.path.join(os.path.dirname(__file__), qml_file))

    # myappid = 'Fast Royal'  # arbitrary string
    # ctypes.windll.shell32.SetCurrentProcessExplicitAppUserModelID(myappid)

    if not engine.rootObjects():
        main_window.socket_worker.stop()
        sys.exit(-1)
    sys.exit(app.exec_())

