import QtQuick 2.0

Rectangle {
    id: rectangle

    property var rect_text
    property var text_color
    property var rect_color
    property var rect_height: 25
    property var font_size: 12
    property var rect_radius: 15
    property var main_width

    visible: rect_text.length != 0 ? true : false

    width: text_id.width
    height: text_id.height

    color: rect_color
    radius: rect_radius

    clip: true

    Text {
        id: text_id
        color: text_color
        font.pixelSize: font_size
        font.family: font_family
        width: (text_id.implicitWidth + 10 <= main_width - 10) ? text_id.implicitWidth + 10 : main_width - 10
        height: implicitHeight + 10
        text:  rect_text
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
