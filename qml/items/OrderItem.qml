import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0
import QtQml.Models 2.1

Item  {
    id: whole_item
    height: main_flow.height

    ListView.onAdd: {
        order_info_flow.forceLayout()
        main_flow.forceLayout()
    }

    property color colorNewOrder: '#2a5e2a'
    property color colorOrder:   '#2f3136'
//    property color colorHoveredOrder:   '#28292a'
    property color colorHoveredOrder:   '#282c30'


    Rectangle {
        id: whole_order_rect
//        width: 1000
        radius: 10
        anchors.fill: parent
        clip: true
        color: color = new_orders.includes(order_id) ? colorNewOrder : colorOrder

//        Component.onCompleted: {
//            color = new_orders.includes(order_id) ? colorNewOrder : toDefaultColorAnimation.running = true
//        }


        ColorAnimation {
            id: toColorNewOrder
            target: whole_order_rect
            property: 'color'
            to: colorNewOrder
            duration: 300
            easing.type: Easing.InOutQuint
        }

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
//                            return main_flow.generic_height
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
                current_width: (main_flow.width - 100) / 3
                parent_width: main_flow.width

                height:  internal.height_calculation()
                color: "#00000000"

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    propagateComposedEvents: true

                    onEntered: { internal.color_function(); toHoveredOrder.running = true }
                    onExited: {toColorOrder.running = true }
                }//Mouse area


                Item {
                    anchors.fill: parent

                    Item {
                        id: id_item
                        width: 50
                        height: top_info_rect_id.height

                        anchors.left: parent.left
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

                        width: top_info_rect_id.width - 50
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
                current_width: (main_flow.width - 100) * 2 / 3
                parent_width: main_flow.width

                height: order_info_flow.height

                onHeightChanged: {
                    order_info_flow.forceLayout()
                    main_flow.forceLayout()
                }

                Item {
                    anchors.fill: parent
                    anchors.margins: 5

                    FlowDetailsItem {id: order_info_flow; width: parent.width}
                }

                MouseArea {
                    id: order_info_mouse_area
                    anchors.fill: parent
                    hoverEnabled: true

                    propagateComposedEvents: true

                    onEntered: { internal.color_function(); toHoveredOrder.running = true }
                    onExited: {toColorOrder.running = true }
                }//Mouse area

            }

            RectInfoEmpty {
                id: buttom_rect_id

                minimum_width: main_flow.default_minimum_width
                current_width: 100
                parent_width:  main_flow.width

                color: '#00000000'

                height:  main_flow.width >= main_flow.default_minimum_width ? main_flow.generic_height  : 35

                RowLayout {
                    id: item1
                    anchors.fill: parent
                    spacing: 0

                    Rectangle {
                        color: "#00000000"
                        Layout.preferredWidth:  buttom_rect_id.width / 2
                        Layout.fillHeight: true

                        MouseArea {
                            id: price_mouse_area
                            anchors.fill: parent
                            hoverEnabled: true

                            propagateComposedEvents: true

                            onEntered: { internal.color_function(); toHoveredOrder.running = true }
                            onExited: {toColorOrder.running = true }
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

                    Rectangle {
                        id: button_rect
                        color: "#00000000"

                        Layout.preferredWidth:  buttom_rect_id.width / 2
                        Layout.fillHeight: true

                        CustomButton {
                            id: lockInButtonId2

                            btnIcon              : '../../components/icons/hand-index-thumb.svg'
                            btnIconHover         : '../../components/icons/hand-index-thumb-fill.svg'
                            btnIconDown          : '../../components/icons/hand-index-fill.svg'

                            btnColor             : "#0f0f0000"
                            btnColorMouseOver    : "#00000000"
                            btnColorMouseDown    : "#00000000"

                            icon_width           : 25
                            icon_height          : 25

                            rect_radius          : 0

                            anchors.fill: parent

                            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

                            onClicked: { backend.lock_in_order(order_id) }
                        }//Buttom
                    }
                }//Main row layout
            }//Rect Info
        }
    }

    Connections {
        target: backend
    }

    Connections {
        target: order_backend
    }

}




/*##^##
Designer {
    D{i:0;formeditorZoom:1.25}
}
##^##*/
