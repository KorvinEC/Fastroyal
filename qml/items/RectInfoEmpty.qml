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
                    return current_width
                }
            }
            else {
                return current_width
            }
        }
    }
}



