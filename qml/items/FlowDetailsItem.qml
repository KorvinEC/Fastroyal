import QtQuick 2.0

Flow {
    id: order_info_flow
//    anchors.fill: parent
    spacing: 5
    clip: true
    anchors.rightMargin: 5
    anchors.leftMargin: 5
    anchors.bottomMargin: 5
    anchors.topMargin: 5

    transitions: Transition {
        NumberAnimation { properties: "x,y"; easing.type: Easing.InOutQuad }
    }

    Rectangle {
        height: 25
    }

    FlowRectInfo {
        id: server_text_rect
        rect_text: (typeof (order_server) !== "undefined" ? order_server : '');
        rect_color: "#4031b3fe"
        text_color: '#31b3fe'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: queue_type_text_rect
        rect_text: (typeof (order_queue_type) !== "undefined" ? order_queue_type :'');
        rect_color: "#4038edb8"
        text_color: "#30e2b8"
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: duoq_text_rect
        rect_text:  (typeof (order_duoq) !== "undefined" ? order_duoq :'');
        rect_color: "#40ff5c2d"
        text_color: "#FF5C2D"
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: order_current_lp_text_rect
        rect_text:  (typeof (order_current_lp) !== "undefined" ? order_current_lp :'');
        rect_color: "#ccffffff"
        text_color: 'Black'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: order_lp_gain_rect
        rect_text:  (typeof (order_lp_gain) !== "undefined" ? order_lp_gain :'');
        rect_color: "#ccffffff"
        text_color: 'Black'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: order_points_rect
        rect_text:  (typeof (order_points) !== "undefined" ? order_points :'');
        rect_color: "#ccffffff"
        text_color: 'Black'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: priority_text_rect
        rect_text:  (typeof (order_priority) !== "undefined" ? order_priority :'');
        rect_color: "#40fe5461"
        text_color: '#fe5461'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: specific_champions_text_rect
        rect_text:  (typeof (order_specific_champions) !== "undefined" ? order_specific_champions :'');
        rect_color: "#33ffc107"
        text_color: '#ffc107'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: appearOffline_rect
        rect_text:  (typeof (order_appear_offline) !== "undefined" ? order_appear_offline :'');
        rect_color: "#33ffffff"
        text_color: '#ffffff'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: role_preference_rect
        rect_text:  (typeof (order_role_preference) !== "undefined" ? order_role_preference :'');
        rect_color: "#33ffc107"
        text_color: '#ffc107'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: spell_order_rect
        rect_text:  (typeof (order_spell_order) !== "undefined" ? order_spell_order :'');
        rect_color: "#33ffffff"
        text_color: '#ffffff'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: order_detailed_info_rect
        rect_text:  (typeof (order_info_order) !== "undefined" ? order_info_order :'');
        rect_color: "#ccffffff"
        text_color: '#000000'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: first_order_rect
        rect_text:  (typeof (order_first_order) !== "undefined" ? order_first_order :'');
        rect_color: "#40fe5461"
        text_color: '#fe5461'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: coaching_rect
        rect_text:  (typeof (order_coaching) !== "undefined" ? order_coaching :'');
        rect_color: "#4031b3fe"
        text_color: '#31b3fe'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: plus_win_rect
        rect_text:  (typeof (order_plus_win) !== "undefined" ? order_plus_win :'');
        rect_color: "#4031b3fe"
        text_color: '#31b3fe'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: streaming_rect
        rect_text:  (typeof (order_streaming) !== "undefined" ? order_streaming :'');
        rect_color: "#4031b3fe"
        text_color: '#31b3fe'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: net_games_rect
        rect_text:  (typeof (order_net_wins) !== "undefined" ? order_net_wins :'');
        rect_color: "#4031b3fe"
        text_color: '#31b3fe'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: token_rect
        rect_text:  (typeof (order_token) !== "undefined" ? order_token :'');
        rect_color: "#33ffffff"
        text_color: '#ffffff'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: mastery_points_rect
        rect_text:  (typeof (order_mastery_points) !== "undefined" ? order_mastery_points :'');
        rect_color: "#33ffffff"
        text_color: '#ffffff'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: champion_rect
        rect_text:  (typeof (order_champion) !== "undefined" ? order_champion : '');
        rect_color: "#33ffc107"
        text_color: '#ffc107'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: bring_friends_rect
        rect_text:  (typeof (order_bring_friends) !== "undefined" ? order_bring_friends : '');
        rect_color: "#33ffffff"
        text_color: '#ffffff'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: marks_rect
        rect_text:  (typeof (order_marks) !== "undefined" ? order_marks :'');
        rect_color: "#33ffffff"
        text_color: '#ffffff'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: platform_rect
        rect_text:  (typeof (order_platform) !== "undefined" ? order_platform :'');
        rect_color: "#4031b3fe"
        text_color: '#31b3fe'
        main_width: order_info_flow.width
    }

    FlowRectInfo {
        id: comment_rect
        rect_text:  (typeof (order_comments) !== "undefined" ? order_comments :'');
        rect_color: "#00000000"
        text_color: '#ffffff'
        main_width: order_info_flow.width
    }
}//Flow

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
