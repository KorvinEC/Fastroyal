import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQml.Models 2.3
import QtQuick.Layouts 1.11
import 'items'

Item {
    id: whole_item
    //    height: parent.height

    property var order_type_info
    property var order_chat_info

    property var order_id
    property var order_nickname
    property var order_server
    property var order_purchase
    property var order_price
    property var order_current_lp
    property var order_lp_gain
    property var order_duoq
    property var order_priority
    property var order_queue_type
    property var order_specific_champions
    property var order_appear_offline
    property var order_coaching
    property var order_plus_win
    property var order_role_preference
    property var order_comments
    property var order_spell_order
    property var order_first_order
    property var order_info_order
    property var order_streaming
    property var order_net_wins
    property var order_token
    property var order_mastery_points
    property var order_champion

    Rectangle {
        id: rectangle
        color: "#00000000"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Item {
            id: left_item
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0

            width: rectangle.width / 2

            Rectangle {
                id: info_rect
                height: 300
                color: "#2f3136"
                radius: 13
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                //            anchors.bottom: parent.bottom
                clip: true
                anchors.topMargin: 0
    //            anchors.bottomMargin: 5
                anchors.rightMargin: 0
                anchors.leftMargin: 5

                Column {
                    id: column
                    anchors.fill: parent
                    anchors.margins: 5


                    Flow {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 0
                        anchors.rightMargin: 0
                        spacing: 5

                        CustomButton {
                            btnIcon: '../components/icons/arrow-left-circle.svg'
                            btnIconDown: '../components/icons/arrow-left-circle-fill.svg'
                            btnIconHover: '../components/icons/arrow-left-circle.svg'

                            btnColor: '#2f3136'
                            btnColorMouseDown: '#2f3136'
                            btnColorMouseOver: '#2f3136'

                            overlayColor: "#b3b3b3"

                            width: 40
                            height: 40

                            icon_width: 30
                            icon_height: 30

                            rect_height: 40
                            rect_width: 40

                            rect_radius: 20

                            CustomToolTip { text: 'Back' }

                            onClicked: {
                                if(order_type_info == 'completed_orders'){
                                    completedOrdersStackView.pop()
                                }
                                else if (order_type_info == 'active_orders') {
                                    activeOrdersStackView.pop()
                                }
                            }
                        }

                        CustomButton {
                            btnIcon: '../components/icons/plus-circle.svg'
                            btnIconHover: '../components/icons/plus-circle.svg'
                            btnIconDown: '../components/icons/plus-circle-fill.svg'

                            btnColor: '#2f3136'
                            btnColorMouseDown: '#2f3136'
                            btnColorMouseOver: '#2f3136'

                            overlayColor: "#b3b3b3"

                            width: 40
                            height: 40

                            icon_width: 30
                            icon_height: 30

                            rect_height: 40
                            rect_width: 40

                            rect_radius: 20

                            CustomToolTip { text: 'Add games' }

                            onClicked: backend.add_order_games(order_id, order_type_info)
                        }

                        CustomButton {
                            btnIcon: order_type_info == 'completed_orders' ? '../components/icons/play-circle.svg' : '../components/icons/check-circle.svg'
                            btnIconHover: order_type_info == 'completed_orders' ? '../components/icons/play-circle.svg' : '../components/icons/check-circle.svg'
                            btnIconDown: order_type_info == 'completed_orders' ? '../components/icons/play-circle-fill.svg' : '../components/icons/check-circle-fill.svg'

                            btnColor: '#2f3136'
                            btnColorMouseDown: '#2f3136'
                            btnColorMouseOver: '#2f3136'

                            overlayColor: "#b3b3b3"

                            width: 40
                            height: 40

                            icon_width: 30
                            icon_height: 30

                            rect_height: 40
                            rect_width: 40

                            rect_radius: 20

                            CustomToolTip { text: order_type_info == 'completed_orders' ? 'Continue order' : 'Close order' }

                            onClicked: completed_orders_popup.open()

                            Popup {
                                id: completed_orders_popup
                                width: 200
                                height: 300
                                modal: true
                                focus: true
                                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

                                Button {
                                    text: order_type_info == 'completed_orders' ? 'Continue order' : 'Close order'
                                    onClicked: backend.close_continue_order(order_id, order_type_info)
                                }
                            }
                        }

                        CustomButton {
                            visible: order_type_info == 'active_orders' ? true : false

                            btnIcon: '../components/icons/reply.svg'
                            btnIconHover: '../components/icons/reply.svg'
                            btnIconDown: '../components/icons/reply-fill.svg'

                            btnColor: '#2f3136'
                            btnColorMouseDown: '#2f3136'
                            btnColorMouseOver: '#2f3136'

                            overlayColor: "#b3b3b3"

                            width: 40
                            height: 40

                            icon_width: 30
                            icon_height: 30

                            rect_height: 40
                            rect_width: 40

                            rect_radius: 20

                            CustomToolTip { text: 'Lock out' }

                            Popup {
                                id: lock_out_popup
                                width: 200
                                height: 300
                                modal: true
                                focus: true
                                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

                                Button {
                                    text: 'Lock out'
                                    onClicked: backend.lock_out_order(order_id, order_type_info)
                                }
                            }

                            onClicked: lock_out_popup.open()
                        }

                        CustomButton {
                            visible: order_type_info == 'active_orders' ? true : false

                            btnIcon: '../components/icons/reply.svg'
                            btnIconHover: '../components/icons/reply.svg'
                            btnIconDown: '../components/icons/reply-fill.svg'

                            btnColor: '#2f3136'
                            btnColorMouseDown: '#2f3136'
                            btnColorMouseOver: '#2f3136'

                            overlayColor: "#b3b3b3"

                            width: 40
                            height: 40

                            icon_width: 30
                            icon_height: 30

                            rect_height: 40
                            rect_width: 40

                            rect_radius: 20

                            CustomToolTip { text: 'Full lock out' }

                            Popup {
                                id: full_lock_out_popup
                                width: 200
                                height: 300
                                modal: true
                                focus: true
                                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

                                Button {
                                    text: 'Full lock out'
                                    onClicked: backend.full_lock_out_order(order_id, order_type_info)
                                }
                            }

                            onClicked: full_lock_out_popup.open()
                        }
                    }


                    Text {
                        color: "#ffffff"
                        id: id_text
                        text: order_id != undefined ? "Order id: " + order_id : ''
                        font.pointSize: 20
                        font.bold: false
                        font.family: font_family

                        width: column.width
                        wrapMode: Text.WordWrap
                    }

                    Text {
                        color: "#ffffff"
                        id: purchase_text
                        text: "Purchse: " + order_purchase
                        font.pointSize: 20
                        font.bold: false
                        font.family: font_family

                        width: column.width
                        wrapMode: Text.WordWrap
                    }


                    Text {
                        color: "#ffffff"
                        id: price_text
                        text: "Price: " + order_price
                        font.pointSize: 20
                        font.bold: false
                        font.family: font_family

                        width: column.width
                        wrapMode: Text.WordWrap
                    }

                    Text {
                        color: "#ffffff"
                        id: nickname_text
                        text: "Summoner name: " + order_nickname
                        font.pointSize: 20
                        font.bold: false
                        font.family: font_family

                        width: column.width
                        wrapMode: Text.WordWrap

                        CustomToolTip {
                            text: 'Open OpGG'
                            visible: op_gg_mouse_area.containsMouse
                        }

                        MouseArea {
                            id: op_gg_mouse_area
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true

                            onDoubleClicked: {
                                backend.open_summoner_op_gg(order_nickname, order_server)
                            }
                        }
                    }

                    Rectangle {
                        id: flow_rect
                        height: 150
                        color: "#00000000"
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.leftMargin: 0

                        FlowDetailsItem { id: flowDetailsItem; anchors.fill: parent }
                    }
                }//Column
            }

            Rectangle {
                id: match_rect
                color: "#00000000"
    //            color: "#35c49d"
//                radius: 13
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: info_rect.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 5
                anchors.bottomMargin: 5
                anchors.leftMargin: 5
//                Component {
//                    id: matchComponent
//                    MatchHistoryItem {}
//                }

                ListView {
                    id: match_history_view
                    anchors.fill: parent
                    add: Transition {
                        NumberAnimation {
                            property: "opacity"
                            duration: 350
                            to: 1
                            from: 0
                        }

                        NumberAnimation {
                            property: "scale"
                            duration: 350
                            to: 1
                            from: 0
                        }
                    }
                    model: ListModel {
                        id: match_model
                    }
                    displaced: Transition {
                        NumberAnimation {
                            properties: "y"
                            easing.type: Easing.OutBounce
                            duration: 350
                        }

                        NumberAnimation {
                            property: "opacity"
                            to: 1
                        }

                        NumberAnimation {
                            property: "scale"
                            to: 1
                        }
                    }
                    clip: true
                    delegate:
                        MatchHistoryItem {
                        width: match_history_view.width
                        height: 70
//                        anchors.left: parent.left
//                        anchors.right: parent.right
//                        anchors.rightMargin: 0
//                        anchors.leftMargin: 0
                    }

                    spacing: 5
                }
                anchors.rightMargin: 0
            }

        }

        MouseArea {
            id: mouseArea
            anchors.left: left_item.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            cursorShape: Qt.SizeHorCursor

            property point clickPos
            width: 5

            onPressed: {
                mouseArea.clickPos  = Qt.point(mouse.x, mouse.y)
            }

            onPositionChanged: {
                var delta = Qt.point(mouse.x-mouseArea.clickPos.x, mouse.y - mouseArea.clickPos.y)
                left_item.width += delta.x;
//                mainWindow.x += delta.x;
//                mainWindow.height += delta.y;
            }
        }

        Item {
            id: chat_item
            anchors.left: mouseArea.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            anchors.rightMargin: 0

            Rectangle {
                id: chat_rect
                color: "#2f3136"
                radius: 13
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: chat_input_rect.top
                anchors.leftMargin: 0
                anchors.bottomMargin: 5
                clip: true
                anchors.topMargin: 0
                anchors.rightMargin: 5

                QtObject {
                    id: internal

                    function get_window_size(){
                        var chat_text_size = chat_text_id.contentWidth
                        if( chat_text_id.contentWidth  <= chat_list_view.width ) {
                            return chat_text_size + 10
                        }
                        else{
                            return chat_list_view.width
                        }
                    }
                }

                Component {
                    id: chatComponent

                    Rectangle {
                        id: rect_id
                        width: chat_text_id.width + 10
                        height: chat_text_id.height + 10
                        color: sender ? "#959595" : "#535353"
                        radius: 10

                        anchors.right: sender ? chat_list_view.contentItem.right : undefined

                        CustomToolTip {
                            text: message_time_info
                            visible: chat_mouse_area.containsMouse
                        }

                        MouseArea {
                            id: chat_mouse_area
                            anchors.fill: parent
                            hoverEnabled: true
                            z: 1
                        }

                        Rectangle {
                            width: 10
                            height: 10

                            color: sender  ? "#959595" : "#535353"
                            anchors.right: sender ? rect_id.right : undefined
                            anchors.bottom: rect_id.bottom
                            z:0
                        }

                        Rectangle {
                            color: '#00000000'
                            id: rect_id_2
                            anchors.fill: parent
                            anchors.margins: 5
                            z: 2

                            Text {
                                id: chat_text_id
                                width: (chat_text_id.implicitWidth + 10 <= chat_list_view.width - 10) ? chat_text_id.implicitWidth + 10 : chat_list_view.width - 10
                                text: message_var
                                font.family: font_family

                                color: sender ? "#000000" : "#ffffff"
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                font.pointSize: 10
                            }
                        }
                    }
                }

                ListView {
                    id: chat_list_view
    //                anchors.bottom: rectangle2.top
                    anchors.fill: parent
                    anchors.margins: 5
                    anchors.leftMargin: 5
                    clip: true
                    spacing: 5
                    verticalLayoutDirection:  ListView.BottomToTop

                    add: Transition {
                        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 350 }
                        NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 350 }
                    }
                    displaced: Transition {
                        NumberAnimation { properties: "y"; duration: 350; easing.type: Easing.OutBounce }
                        NumberAnimation { property: "opacity"; to: 1.0 }
                        NumberAnimation { property: "scale"; to: 1.0 }
                    }

                    model: ListModel { id:chat_model }
                    delegate: chatComponent
                }
            }

            Rectangle {
                id: chat_input_rect
                y: 425
                height: 50
                color: "#00000000"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 5
                anchors.leftMargin: 0
                anchors.bottomMargin: 5

                CustomTextField {
                    id: customTextField
                    anchors.fill: parent

                    Keys.onEnterPressed: {
                        console.log(customTextField.text)
                        if(customTextField.text.length > 0){
                            backend.send_message(customTextField.text, order_id)
                            customTextField.text = ''
    //                        console.log('sending message', customTextField.text)
                        }
                    }

                    Keys.onEscapePressed: {
                        console.log('escape')
                        customTextField.focus = false
                    }

                    Keys.onReturnPressed: {
                        console.log('enter')
                        if(customTextField.text.length > 0){
                            backend.send_message(customTextField.text, order_id)
                            customTextField.text = ''
    //                        console.log('sending message', customTextField.text)
                        }
                    }

                    onTextChanged: {
                        /* Check if enter key was pressed (charCode 10), remove it from the text, update
                         the item value and send accepted event*/
                        if(customTextField.text.length > 0 && customTextField.text.charCodeAt(customTextField.text.length-1) === 10) {
                            var txt = customTextField.text.substring(0,customTextField.text.length-1);
                            txt = txt.trim();
                            customTextField.text = txt;
                            console.log("emit accepted signal");
                            accepted();
                        }
                    }
                }

                CustomButton {
                    btnIcon: '../components/icons/cursor.svg'
                    btnIconHover: '../components/icons/cursor.svg'
                    btnIconDown: '../components/icons/cursor-fill.svg'

                    btnColor: '#00000000'
                    btnColorMouseDown: '#00000000'
                    btnColorMouseOver: '#00000000'

                    overlayColor: "#b3b3b3"

                    width: 50
                    height: 50

                    icon_width: 30
                    icon_height: 30

                    rect_height: 40
                    rect_width: 40

                    rect_radius: 20

                    anchors.right: parent.right

                    CustomToolTip { text: 'Send message' }

                    onClicked: {
                        if(customTextField.text.length > 0){
                            backend.send_message(customTextField.text, order_id)
                            customTextField.text = ''
                        }
                    }
                }
            }
        }
    }
    Connections {
        target: backend
    }

    Connections {
        target: order_backend

        function onMessageSignal(order_id_msg, message_data){
            if(order_id == order_id_msg){
                chat_model.insert(0,{
                    'message_var': message_data.message,
                    'sender': message_data.sender,
                    'message_time_info': message_data.message_info
                })
            }
        }

        function onMatchHistorySignal(order_id_msg, match_data){
            if(order_id == order_id_msg){
                var data = {
                    'match_type': match_data.type,
                    'match_result': match_data.result,
                    'match_champion': match_data.champion,
                    'match_champion_image': match_data.championImage,
                    'match_time': match_data.time,
                    'match_last_time': match_data.last_time,
                    'match_length': match_data.length,
                    'match_kills': match_data.kills,
                    'match_deaths': match_data.deaths,
                    'match_assists': match_data.assists,
                    'match_ratio': match_data.ratio,
                    'match_level': match_data.level,
                    'match_cs': match_data.cs,
                    'match_csps': match_data.csps,
                    'match_kill_participation': match_data.killParticipation,
                    'match_spell1': match_data.spell1,
                    'match_spell1Image': match_data.spell1Image,
                    'match_spell2': match_data.spell2,
                    'match_spell2Image': match_data.spell2Image,

                    'item_0_image': match_data.item_0_image,
                    'item_1_image': match_data.item_1_image,
                    'item_2_image': match_data.item_2_image,
                    'item_3_image': match_data.item_3_image,
                    'item_4_image': match_data.item_4_image,
                    'item_5_image': match_data.item_5_image,
                    'item_6_image': match_data.item_6_image,
                }
                match_model.insert(0, data)
//                match_history_view.positionViewAtStart()
            }
        }
    }

    Component.onCompleted: {
        backend.get_matches(order_id)
        order_chat_info.forEach((element) => {
            chat_model.insert(0,{
                'message_var': element.message,
                'sender': element.sender,
                'message_time_info': element.message_info
            })
        })
    }
} //Item



/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.1;height:480;width:640}
}
##^##*/
