import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQml.Models 2.1

Item {
    id: order_item
    property var item_opasity: 1

    clip: true
    width: 300
    height: message_info.height + message_text.height + 20
    opacity: item_opasity

    QtObject{
        id: internal

        property var dynamicColor:
            if(websocket_data_type == 'debug'){
                return '#6f727b'
            }
            else if(websocket_data_type == 'message' || websocket_data_type =='success') {
                return '#28a745'
            }
            else if(websocket_data_type == 'warning') {
                return '#ffc107'
            }
            else if(websocket_data_type == 'danger') {
                return '#dc3545'
            }
            else if(websocket_data_type == 'primary') {
                return '#007bff'
            }
            else{
                return "#6f727b"
            }

        property var dynamicTextColor: {
            if(websocket_data_type == 'debug'){
                return '#ffffff'
            }
            else if(websocket_data_type == 'message' || websocket_data_type =='success') {
                return '#E6FFEB'
            }
            else if(websocket_data_type == 'warning') {
                return '#4F3C02'
            }
            else if(websocket_data_type == 'danger') {
                return '#FFE6E8'
            }
            else if(websocket_data_type == 'primary') {
                return '#CCE5FF'
            }
            else{
                return "#ffffff"
            }
        }

        property var delete_order: {
            if(websocket_data_type == 'primary'){
                return false

            }
            if(websocket_data_type == 'message'){
                return false
            }

            else {
                return true
            }
        }
    }


    Rectangle {
        id: rectangle
//        height: 40
        color: internal.dynamicColor
        radius: 10
        border.width: 1
        anchors.fill: parent
        opacity: parent.opacity

        ColumnLayout {
            id: columnLayout
            anchors.fill: parent
            spacing: 0
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            opacity: parent.opacity

            RowLayout {
                id: rowLayout

                Text {
                    id: message_info
                    color: internal.dynamicTextColor
                    text: websocket_data_info
                    font.pixelSize: 12

                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    id: message_time
                    color: internal.dynamicTextColor
                    text: websocket_data_time
                    font.pixelSize: 9
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                    font.family: font_family

//                    Layout.preferredWidth: columnLayout.width
                }
            }

            Text {
                id: message_text
                color: internal.dynamicTextColor
                text: websocket_data_message
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                Layout.preferredWidth: columnLayout.width
                font.family: font_family
            }


        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true


            onClicked: {
                websocketInfoList.remove(index)
            }

//            onEntered: {
//                console.log('entered')
//                order_item.opacity = 1
//            }

            onExited: {
                destroy_timer.running = true
            }
        }

        Timer {
            id: destroy_timer

            interval: 3000
            running: internal.delete_order
            repeat: false
            onTriggered: {
                websocketInfoList.remove(index)
            }
        }
    }
}





/*##^##
Designer {
    D{i:0;formeditorZoom:1.5}
}
##^##*/
