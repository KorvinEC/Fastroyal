import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

Button {
    id: lockInBtn
    property url btnIcon:       '../../components/icons/hand-index-thumb.svg'
    property url btnIconHover:  '../../components/icons/hand-index-thumb-fill.svg'
    property url btnIconDown:   '../../components/icons/hand-index-fill.svg'
    property color colorMouseOver: "#23272e"
    property color colorMouseDown: '#007d00'
    property color colorDefault:   '#2f3136'
    property int icon_width:   25
    property int icon_height:   25

    QtObject{
        id: internal

        property var dynamicColor: if(lockInBtn.down){
                                       lockInBtn.down ? colorDefault : colorDefault
                                   }
                                   else{
                                       lockInBtn.hovered ? colorDefault : colorDefault
                                   }

        property var dynamicIcon: if(lockInBtn.down){
                                      lockInBtn.down ? btnIconDown : btnIcon
                                  }else{
                                      lockInBtn.hovered ? btnIconHover : btnIcon
                                  }
    }


    background: Rectangle{
        id: bgLockInBtn
        color: internal.dynamicColor

        Image {
            id: iconLockInBtn
            source: internal.dynamicIcon
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            visible: true
            antialiasing: false
            sourceSize.width: icon_width
            sourceSize.height: icon_height
            width: icon_width
            height: icon_height
        }

        ColorOverlay {
            anchors.fill: iconLockInBtn
            source: iconLockInBtn
            color: '#CCCCCC'
            antialiasing: false
        }
   }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:8}
}
##^##*/
