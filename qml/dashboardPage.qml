import QtQuick 2.0
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import 'items'
import QtQml.Models 2.1


Item {
    id: main_item

    property var new_orders: []
    property int row_height: 50
    property int order_list_count: orderList.count

    Rectangle {
        id: rectangle
        color: "#00000000"
        anchors.fill: parent
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.bottomMargin: 0
        anchors.topMargin: 0

        Row {
            id: row
            height: row_height
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            spacing: 5

            CustomButton {
                anchors.verticalCenter: parent.verticalCenter

                btnIcon: '../components/icons//arrow-repeat.svg'
                btnIconDown: '../components/icons//arrow-repeat.svg'
                btnIconHover: '../components/icons//arrow-repeat.svg'

                btnColor: '#40444b'
                btnColorMouseDown: '#00f000'
                btnColorMouseOver: '#2a2c30'

                width: 40
                height: 40

                icon_width: 30
                icon_height: 30

                rect_height: 40
                rect_width: 40

                rect_radius: 20

                onClicked: backend.load_orders()

                CustomToolTip { text: 'Refresh' ; inverted: true }
            }

            Button {
                visible: false
                text: "Delete orders"
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.topMargin: 5
                onClicked: {
                    for (var i=0; i<=orderList.count; ++i){
                        backend.delete_order(orderList.get(i).order_id)
                    }
                }
            }

            Button {
                visible: false
                text: "play sound"
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.topMargin: 5
                onClicked: {
                        backend.play_sound()
                        console.log('New orders: ', new_orders)
                    }
            }

            Button {
                visible: false
                text: 'Add order'
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.topMargin: 5

                onClicked: {
                    orderList.insert(0, { 'order_purchase': 'Added' })
                }
            }

//            Button {
//                text: 'Insert order'
//                anchors.top: parent.top
//                anchors.bottom: parent.bottom
//                anchors.bottomMargin: 5
//                anchors.topMargin: 5

//                onClicked: {
//                    orderList.insert(0, {'order_purchase': 'Inserted'})
////                    addOrder(temp_data)
//                }
//            }
        }//Row

        Component {
            id: listViewComponent
            OrderItem {
                width: orderListView.width - 15
            }
        }//Component

        Item {
            id: item2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: row.bottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.topMargin: 0

            ListView {
                id: orderListView
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.fill: parent
                anchors.bottomMargin: 5
                spacing: 5
                bottomMargin: 0
                clip: true

                ScrollBar.vertical: ScrollBar {  }

                delegate: listViewComponent

                model: ListModel { id: orderList }

                add: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 350 }
                    NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 350 }
                }
                displaced: Transition {
                    NumberAnimation { properties: "y"; duration: 350; easing.type: Easing.OutBounce }
                    NumberAnimation { property: "opacity"; to: 1.0 }
                    NumberAnimation { property: "scale"; to: 1.0 }
                }
            } //ListView id: orderListView
        }//Item
    }//Rectangle

    // Create new order
    function addOrder(order_data){
        var data_dict = {};

        if(order_data.id)                { data_dict['order_id']                 = order_data.id }
        if(order_data.nickname)          { data_dict['order_nickname']           = order_data.nickname}
        if(order_data.server)            { data_dict['order_server']             = order_data.server[1]}
        if(order_data.purchase)          { data_dict['order_purchase']           = order_data.purchase}
        if(order_data.price)             { data_dict['order_price']              = order_data.price}
        if(order_data.currentLp)         { data_dict['order_current_lp']         = order_data.currentLp}
        if(order_data.lpGain)            { data_dict['order_lp_gain']            = order_data.lpGain}
        if(order_data.duoQ)              { data_dict['order_duoq']               = order_data.duoQ}
        if(order_data.priorityOrder)     { data_dict['order_priority']           = order_data.priorityOrder}
        if(order_data.queue)             { data_dict['order_queue_type']         = order_data.queue}
        if(order_data.specificChampions) { data_dict['order_specific_champions'] = order_data.specificChampions}
        if(order_data.appearOffline)     { data_dict['order_appear_offline']     = order_data.appearOffline}
        if(order_data.coaching)          { data_dict['order_coaching']           = order_data.coaching}
        if(order_data.plusWin)           { data_dict['order_plus_win']           = order_data.plusWin}
        if(order_data.rolePreference)    { data_dict['order_role_preference']    = order_data.rolePreference}
        if(order_data.comments)          { data_dict['order_comments']           = order_data.comments}
        if(order_data.spellOrder)        { data_dict['order_spell_order']        = order_data.spellOrder}
        if(order_data.firstOrder)        { data_dict['order_first_order']        = order_data.firstOrder}
        if(order_data.info)              { data_dict['order_info_order']         = order_data.info}
        if(order_data.streaming)         { data_dict['order_streaming']          = order_data.streaming}
        if(order_data.netGame)           { data_dict['order_net_wins']           = order_data.netGame}
        if(order_data.token)             { data_dict['order_token']              = order_data.token}
        if(order_data.masteryPoints)     { data_dict['order_mastery_points']     = order_data.masteryPoints}
        if(order_data.champion)          { data_dict['order_champion']           = order_data.champion}
        if(order_data.bringFriend)       { data_dict['order_bring_friend']       = order_data.bringFriend}
        if(order_data.marks)             { data_dict['order_marks']              = order_data.marks}
        if(order_data.platform)          { data_dict['order_platform']           = order_data.platform}

        orderList.insert(0, data_dict)
        if (order_data.new_order){
            new_orders.push(order_data.id)
        }
    }

    Connections {
        target: backend
    }

    Connections {
        target: order_backend
        ignoreUnknownSignals: true

        function onNewOrderSignal(order_data){
            addOrder(order_data)
//            try {
//                addOrder(order_data)
//            }
//            catch (error) {
//                print ("Error loading QML : ")
//                for (var i = 0; i < error.qmlErrors.length; i++) {
//                    console.log("lineNumber: " + error.qmlErrors[i].lineNumber)
//                    console.log("columnNumber: " + error.qmlErrors[i].columnNumber)
//                    console.log("fileName: " + error.qmlErrors[i].fileName)
//                    console.log("message: " + error.qmlErrors[i].message)
//                }
//            }
        }

        function onRemoveOrderSignal(order_id){
            for (var i=0; i<orderList.count; ++i){
                if(orderList.get(i).order_id == order_id){
                    orderList.remove(i)
                    main_item.new_orders.splice(new_orders.indexOf(order_id), 1)
                }
            }
        }
    }//Connections
}//Item


/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.9;height:480;width:640}
}
##^##*/
