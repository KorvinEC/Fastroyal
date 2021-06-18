import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQml.Models 2.1
import 'items'


Item {
    id: completedOrdersItem
    anchors.fill: parent
    property int row_height: 50

    Component {
        id: listViewComponent
        OrderItemNoBtn {
            width: completedOrdersListView.width - 15
            MouseArea {
                anchors.fill: parent

                cursorShape: Qt.PointingHandCursor

                onDoubleClicked: {
                    backend.get_order_info(order_id, 'completed_orders')
                }
            }
        }
    }//Component


    Row {
        id: row
        height: row_height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: 5
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.topMargin: 0

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

            CustomToolTip { text: 'Refresh'; inverted: true }

            onClicked: backend.load_completed_orders()
        }
    }

    StackView {
        id: completedOrdersStackView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: row.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 0

        initialItem:
            Item {
//                anchors.fill: parent
                ListView {
                    id: completedOrdersListView
                    anchors.fill: parent
//                    cacheBuffer: 500
                    spacing: 5
                    anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    anchors.bottomMargin: 5
                    anchors.topMargin: 0
                    clip: true

                    ScrollBar.vertical: ScrollBar {  }

                    model: ListModel { id: completedOrdersModel }
                    delegate: listViewComponent
                }
            }
    }


    Connections {
        target: backend
    }

    Connections {
        target: order_backend

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

            if(order_data.status)            { data_dict['order_status']             = order_data.status}

            completedOrdersModel.insert(0, data_dict)
        }

        function onCompletedOrderSignal(data){
            addOrder(data)
        }

        function onRemoveCompletedOrderSignal(order_id){

            for (var i=0; i<completedOrdersModel.count; ++i){
                if(completedOrdersModel.get(i).order_id == order_id){
                    completedOrdersModel.remove(i)
                }
            }
        }

        function onOrderInfoSignal(order_type_info, order_data){
            if(order_type_info == 'completed_orders'){
                var data_dict = {}
                if(order_data.id)                { data_dict['order_id']                 = order_data.id }
                if(order_data.nickname)          { data_dict['order_nickname']           = order_data.nickname}
                if(order_data.server)            { data_dict['order_server']             = order_data.server[0]}
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

                if(order_data.status)            { data_dict['order_status']             = order_data.status}

                if(order_data.Chat_messages)     { data_dict['order_chat_info']          = order_data.Chat_messages}

                data_dict['order_type_info'] = order_type_info

                completedOrdersStackView.push(Qt.resolvedUrl('OrderInfoPage.qml'), data_dict)
            }
        }
    }
}







/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:1.25;height:480;width:640}
}
##^##*/
