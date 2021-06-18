import QtQuick 2.0
import QtQml.Models 2.1
import QtQuick.Controls 2.0
import 'items'

Item {
    id: item1


    ListView {
        id: websocketInfoView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.fill: parent
        anchors.topMargin: 5
        anchors.rightMargin: 45
        cacheBuffer: 500
        spacing: 5
        bottomMargin: 0
        clip: true
        visible: true

        delegate: ConsoleInfo { width: websocketInfoView.width - 10 }
        model: ListModel { id: websocketInfoList }

        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 350 }
            NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 350 }
        }
        displaced: Transition {
            NumberAnimation { properties: "y"; duration: 350; easing.type: Easing.OutBounce }
            NumberAnimation { property: "opacity"; to: 1.0 }
            NumberAnimation { property: "scale"; to: 1.0 }
        }
        remove: Transition {
            NumberAnimation { property: "opacity"; to: 0; duration: 50 }
        }
    } //ListView id: websocketInfoView


    CustomButton {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.rightMargin: 0

        property bool active: true

        btnIcon: active ? '../components/icons//bell-fill.svg' : '../components/icons//bell.svg'
        btnIconDown: active ? '../components/icons//bell-fill.svg' : '../components/icons//bell.svg'
        btnIconHover: active ? '../components/icons//bell-fill.svg' : '../components/icons//bell.svg'

        btnColor: '#40444b'
        btnColorMouseDown: '#00f000'
        btnColorMouseOver: '#2a2c30'

        width: 40
        height: 40

        icon_width: 30
        icon_height: 30

        rect_height: 40
        rect_width: 40

        rect_radius: 20

        CustomToolTip { text: websocketInfoView.visible ? 'Hide notifications' : 'Show notifications' ; inverted: true }

        onClicked: {
            if(websocketInfoView.visible) {
                websocketInfoView.visible = false
                active = false
            }else{
                websocketInfoView.visible = true
                active = true
            }
        }
    }



    Connections {
        target: order_backend

        function add_data(websocket_data){
            var data_dict = {}
            data_dict['websocket_data_type']    = websocket_data.type
            data_dict['websocket_data_info']    = websocket_data.info
            data_dict['websocket_data_message'] = websocket_data.message
            data_dict['websocket_data_time']    = websocket_data.time

            websocketInfoList.append(data_dict)
        }

        function onSocketSignal(websocket_data){
            add_data(websocket_data)
        }
    }//Connections

    Connections {
        target: order_backend

        function onOrderAddGamesSignal(websocket_data){
            add_data(websocket_data)
        }
    }
}



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
