import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0
import QtQml.Models 2.1

Item  {
    id: whole_item
//    height: order_info_rect.height
    height: main_flow.height

    ListView.onAdd: {
        order_info_flow.forceLayout()
        main_flow.forceLayout()
    }

    property color colorNewOrder: '#2a5e2a'
    property color colorOrder:   '#2f3136'
    property color colorHoveredOrder:   '#282c30'

    property bool orderButton: true

    ColorAnimation {
        id: toColorOrder
        target: whole_order_rect
        property: 'color'
        to: colorOrder
        duration: 300
        easing.type: Easing.InOutQuint
    }


    ColorAnimation {
        id: toHoveredOrder
        target: whole_order_rect
        property: 'color'
        to: colorHoveredOrder
        duration: 150
        easing.type: Easing.InOutQuint
    }

    Rectangle {
        id: whole_order_rect
        radius: 10
        anchors.fill: parent
        clip: true
        color: colorOrder

        //        transitions: Transition {
        //            ColorAnimation {
        //                duration: 200
        //            }
        //        }

        Flow {
            id: main_flow
            width: parent.width

            property var generic_height: order_info_flow.childrenRect.height + 10
            property var default_minimum_width: 500

            QtObject {
                id: internal
                function height_calculation() {
                    if(main_flow.width >= main_flow.default_minimum_width){
                        if((text_purchase_id.implicitHeight + 10) > main_flow.generic_height) {
                            return text_purchase_id.implicitHeight + 10
                        }
                        else {
                            return main_flow.generic_height
                        }
                    }
                    else {
                        return text_purchase_id.implicitHeight + 10
                    }
                }

                function color_function() {
                    if(new_orders.indexOf(order_id) >= 0) {
                        new_orders.splice(new_orders.indexOf(order_id), 1)
                        toColorOrder.running = true
        //                        toColorNewOrder.running = true
                    }
                }
            }

            RectInfoEmpty {
                id: top_info_rect_id
                minimum_width: main_flow.default_minimum_width
                current_width: (main_flow.width - 50) / 3
                parent_width: main_flow.width

                height:  internal.height_calculation()

//                color: '#0000000'

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    propagateComposedEvents: true

                    onEntered: { toHoveredOrder.running = true }
                    onExited: { toColorOrder.running = true }
                }//Mouse area

                Item {
                    anchors.fill: parent

                    Item{
                        id: image_item
                        width: order_status == 'Paused' ? 35 : 0
                        height: top_info_rect_id.height

                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        Image {
                            id: pauseIcon
                            source: '../../components/icons/pause-circle.svg'
                            anchors.horizontalCenter: parent.horizontalCenter
                            visible: order_status == 'Paused' ? true : false
                            anchors.verticalCenter: parent.verticalCenter
                            antialiasing: false
                            sourceSize.width: 25
                            sourceSize.height: 25
                            width: 25
                            height: 25

                            ColorOverlay {
                                anchors.fill: pauseIcon
                                source: pauseIcon
                                antialiasing: false
                                color: '#ffffff'
                            }
                        }

                    }


                    Item {
                        id: id_item
                        width: 50
                        height: top_info_rect_id.height

                        anchors.left: image_item.right
                        anchors.leftMargin: 0

                        Text {
                            text: order_id != undefined ? order_id : ''

                            font.family: font_family
                            font.pixelSize: 12

                            color: '#ffffff'

                            anchors.fill: parent

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        } // Text
                    } // Item

                    Item {
                        id: purchase_item

                        width: top_info_rect_id.width - 75
                        height: top_info_rect_id.height

                        anchors.right: parent.right
                        anchors.rightMargin: 0

                        Text {
                            id: text_purchase_id
//                            text: order_purchase != undefined ? order_purchase + ' ' + main_flow.generic_height  +' '+  : ''
                            text: order_purchase != undefined ? order_purchase : ''
                            anchors.fill: parent
                            anchors.margins: 5

                            font.family: font_family
                            font.pixelSize: 18

                            color: '#ffffff'

                            horizontalAlignment: main_flow.width > main_flow.default_minimum_width ? Text.AlignLeft : Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.WordWrap
                        }// Text
                    } // Item
                }// Item
            }// Rect info

            RectInfoEmpty {
                id: order_info_rect

                minimum_width: main_flow.default_minimum_width
                current_width: (main_flow.width - 50) * 2 / 3
                parent_width: main_flow.width

                height: order_info_flow.height

                onHeightChanged: {
                    order_info_flow.forceLayout()
                    main_flow.forceLayout()
                }

                MouseArea {
                    id: mouseArea2
                    anchors.fill: parent
                    hoverEnabled: true

                    propagateComposedEvents: true

                    onEntered: { toHoveredOrder.running = true }
                    onExited: { toColorOrder.running = true }
                }//Mouse area

                Item {
                    anchors.fill: parent
                    anchors.margins: 5

                    FlowDetailsItem {id: order_info_flow; width: parent.width}
                }

            }

            RectInfoEmpty {
                id: buttom_rect_id

                minimum_width: main_flow.default_minimum_width
                current_width: 50
                parent_width:  main_flow.width

                color: '#00000000'

                height:  main_flow.width >= main_flow.default_minimum_width ? main_flow.generic_height  : 35

                MouseArea {
                    id: mouseArea3
                    anchors.fill: parent
                    hoverEnabled: true

                    propagateComposedEvents: true

                    onEntered: { toHoveredOrder.running = true }
                    onExited: { toColorOrder.running = true }
                }//Mouse area

                Text {
                    text: order_price != undefined ? order_price : ''
                    font.family: font_family
                    font.pixelSize: 12

                    color: '#ffffff'

                    anchors.fill: parent

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                } // Text
            }
        }
    }
    Connections {
        target: order_backend
    }

}








/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
