import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

TextField {
    id: textField

    // Custom Properties
//    property color colorDefault: "#36393f"
    property color colorDefault: "#2f3136"
    property color colorOnFocus: "#36393f"
    property color colorMouseOver: "#323439"

//    property color colorDefault: "#2f3136"
//    property color colorMouseOver: "#36393f"
//    property color colorOnFocus: '#535760'


//    btnColor:  '#202224'
//    btnColorMouseOver: '#2a2c30'
//    btnColorMouseDown: "#40444b"

//    btnColor:  '#202224'
//    btnColorMouseOver: '#202224'
//    btnColorMouseDown: '#202224'


    QtObject{
        id: internal

        property var dynamicColor: if(textField.focus){
                                        textField.focus ? colorOnFocus : colorDefault
                                   }else{
                                       textField.hovered ? colorMouseOver : colorDefault
                                   }
    }

    implicitWidth: 300
    implicitHeight: 40
    placeholderText: qsTr("Type something")
    color: "#ffffff"
    placeholderTextColor: "#6fffffff"
    font.family: font_family

    cursorVisible: true

    background: Rectangle {
        color: internal.dynamicColor
        radius: 10
    }

    selectByMouse: true
    selectedTextColor: "#FFFFFF"
    selectionColor: "#6fffffff"
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:40;width:640}
}
##^##*/
