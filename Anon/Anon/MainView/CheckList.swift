//
//  CheckList.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

import Foundation

enum CheckList {
    case highAltitudeAndAccess
    case structureAndFormwork
    case excavationAndEarthwork
    case others
    case finishingAndPainting
    case mechanicalAndElectrical
    case weldingAndRepair
    case transportAndHandling
    case housekeeping
    case cuttingAndProcessing
    case rebarAndConnection
    case concretePlacement
    case demolitionAndDismantling
    
    // 공공데이터로 가능하면 갱신
    
    var title: [CheckListText] {
        switch self {
        case .highAltitudeAndAccess:
            return [
                CheckListText(title: "비계 상 추락방지", content: "작업발판 구조, 안전난간 설치 상태, 추락방호망 설치"),
                CheckListText(title: "철골작업 시 추락방지", content: "승강로 설치, 안전대 부착설비, 안전대 이상유무"),
                CheckListText(title: "지붕작업 시 추락방지", content: "폭 30cm 이상 발판, 추락방호망, 안전난간 설치"),
                CheckListText(title: "개구부 추락방지", content: "안전난간, 울타리, 덮개 등 방호조치"),
                CheckListText(title: "비계 조립상태", content: "발판재료 손상, 접속부 풀림, 비계기둥 변형·침하")
            ]

        case .structureAndFormwork:
            return [
                CheckListText(title: "흙막이 지보공 안전조치", content: "부재접합, 교차부, 손상·부식 점검, 버팀보·띠장 설치"),
                CheckListText(title: "거푸집 동바리 등 가시설", content: "연결부·접속부 이상 유무, 지반 침하 여부"),
                CheckListText(title: "지보공 적기 설치", content: "굴착과 동시에 설치 여부 확인")
            ]

        case .excavationAndEarthwork:
            return [
                CheckListText(title: "주변지반 이상유무", content: "지형·지질·지하수위·용수 상태 점검"),
                CheckListText(title: "지하매설물 조사", content: "가스관, 상하수도관, 전기·통신케이블 위치 확인"),
                CheckListText(title: "적정 굴착 기울기 확보", content: "지반조건·주변 여건 반영"),
                CheckListText(title: "비탈면 관리", content: "붕괴·낙반 방지, 배수로 설치, 토사 유출 방지"),
                CheckListText(title: "지반 침하·균열 점검", content: "매일 순회 점검, 대책 수립")
            ]

        case .others:
            return [
                CheckListText(title: "주변 도로 및 배수시설", content: "노면 폭·요철·결빙 제거, 안내 표지판 설치"),
                CheckListText(title: "밀폐공간 작업", content: "산소·유해가스 측정, 환기, 감시인 배치")
            ]

        case .finishingAndPainting:
            return [
                CheckListText(title: "폴리우레탄폼 사용 작업", content: "화기사용 분리, 환기, 차폐시설, 소화기 비치, MSDS 설치")
            ]

        case .mechanicalAndElectrical:
            return [
                CheckListText(title: "가설전기", content: "누전차단기 설치 여부, 전기용품 적정 사용"),
                CheckListText(title: "화재경보·비상탈출", content: "대피로 표지, 조명, 경보 설비")
            ]

        case .weldingAndRepair:
            return [
                CheckListText(title: "용접·용단 작업 전후 안전", content: "가스농도 측정, 인화성물질 격리, 불티 방지덮개, 소화기 비치"),
                CheckListText(title: "장치 점검", content: "호스 균열, 가스누출 여부, 역화방지기 부착")
            ]

        case .transportAndHandling:
            return [
                CheckListText(title: "타워크레인 및 양중기", content: "강풍 시 작업제한, 지지 보강, 자재 결속"),
                CheckListText(title: "가설도로", content: "교통 안내표지판, 복공판 상태, 미끄럼 방지")
            ]

        case .housekeeping:
            return [
                CheckListText(title: "현장 정리정돈(공종 공통)", content: "자재 고정, 가설물 결속, 비산 방지")
            ]

        case .cuttingAndProcessing:
            return [
                CheckListText(title: "용접·용단 안전조치", content: "불꽃·불티 비산 방지, 소화기 비치")
            ]

        case .rebarAndConnection:
            return [
                CheckListText(title: "흙막이 부재 접합부", content: "손상·변형, 부식 점검"),
                CheckListText(title: "지보공·버팀보 설치", content: "결합상태 이상유무")
            ]

        case .concretePlacement:
            return [
                CheckListText(title: "밀폐공간 작업 고려", content: "양생구간 환기, 감시인 배치"),
                CheckListText(title: "개구부·비계 안전관리", content: "타설 구간 추락방지, 발판 점검")
            ]

        case .demolitionAndDismantling:
            return [
                CheckListText(title: "가시설 해체 시 추락방지", content: "안전난간, 방호망, 안전대 부착설비 유지"),
                CheckListText(title: "장비 작업계획", content: "굴삭기·덤프 등 해체장비 계획 및 유도자 배치")
            ]
        }
    }
}

struct CheckListText {
    var title: String
    var content: String
}
