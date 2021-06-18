import QtQuick 2.0
import QtQuick.Controls 2.15
//import QtQuick.Layouts 1.3

Item {
    Grid  {
        id: grid
        anchors.fill: parent
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.bottomMargin: 5
        anchors.topMargin: 5
        columns: 3

        Rectangle {
            id: rectangle
            width: parent.width / 3
            height: 150
            color: '#2f3136'
            radius: 12

            Text {
                id: text1
                height: 58
                color: "#ffffff"
                text: qsTr("Notification volume")
                font.family: font_family
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                textFormat: Text.AutoText
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.leftMargin: 0
            }

            Slider {
                id: slider
                y: 87
                anchors.left: parent.left
                anchors.right: parent.right
                live: true
                font.pointSize: 8
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                onMoved:  {
                    backend.set_volume(value)
                }

                Component.onCompleted: {
                    console.log('completed')
                    backend.load_settings()
                }
            }

        }
    }

    Connections {
        target: backend
    }

    Connections {
        target: order_backend


        function onSettingsSignal(value){
            console.log('in signal', value)
            slider.value = value
        }
    }

//    Connections {
//        target: order_backend
//    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.9;height:480;width:640}
}
##^##*/
