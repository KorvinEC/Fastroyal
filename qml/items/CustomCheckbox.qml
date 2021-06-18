import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

CheckBox {
    id: checkBox_id
    checked: false
    property var colorDefault: "#2f3136"
    property var colorActive: "#36393f"
    property var colorHovered: "#36393f"

    property var textColor: "#ffffff"

    QtObject{
        id: internal

        property var dynamicColor: if(checkBox_id.down){
                                        checkBox_id.down ? colorActive : colorDefault
                                   }else{
                                       checkBox_id.hovered ? colorHovered : colorDefault
                                   }
    }


    indicator: Rectangle {
        id: indicator_rect

        anchors.fill: parent
        anchors.margins: 1

        anchors.left: parent.left
        anchors.top: parent.top

        radius: 10

        color: internal.dynamicColor
        border.color: "#00000000"

        Image {
            id: iconBtn
            source: '../../components/icons/check2.svg'

            fillMode: Image.PreserveAspectFit

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter


            sourceSize.width: 67
            sourceSize.height: 67

            width: 30
            height: 30

            visible: checked

            antialiasing: false

            ColorOverlay {
                anchors.fill: iconBtn
                source: iconBtn
                color: '#ffffff'
                antialiasing: true
           }
        }
    }

    contentItem: Text {
        anchors.left: indicator_rect.right
        anchors.leftMargin: 5
        verticalAlignment: Text.AlignVCenter

        text: checkBox_id.text
        font: checkBox_id.font

        color: textColor
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:4}
}
##^##*/
