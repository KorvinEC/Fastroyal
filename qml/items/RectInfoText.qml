import QtQuick 2.0
import QtQuick.Layouts 1.11


Rectangle {
    id: rectangle
    property var text_str
    property var text_color: '#ffffff'
    property var rect_color: '#00000000'

    property var minimum_width
    property var current_width
    property var parent_width

    property var font_size: 12

    property bool align: true

    width: internal.width_calculation()

    color: rect_color

    QtObject {
        id: internal

        function width_calculation(){
            if(current_width < minimum_width) {
                if(parent_width < minimum_width){
                    return parent_width
                }
                else{
                    return  current_width
                }
            }
            else {
                return current_width
            }
        }
    }

    Text {
        id: text_id

        color: text_color

        text: text_str != undefined ? text_str : ''
        anchors.fill: parent
        anchors.margins: 5

        font.family: font_family
        font.pixelSize: font_size
        horizontalAlignment: align == true ? Text.AlignHCenter : Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }
}


/*##^##
Designer {
    D{i:0;height:35;width:0}
}
##^##*/
