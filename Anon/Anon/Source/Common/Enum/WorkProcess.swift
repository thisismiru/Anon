//
//  CheckList.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

//
//  CheckList.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

import Foundation

struct CheckListText {
    var title: String   // e.g., "Scaffold Fall Protection"
    var content: String // e.g., "Platform structure, guardrails, safety nets installed"
}

/// Work processes (concise English case names)
enum WorkProcess: CaseIterable {
    case height          // Working at height
    case structure       // Structure & formwork
    case excavation      // Excavation & earthwork
    case finishing       // Finishing & painting/coating
    case electrical      // Mechanical & electrical (temporary power etc.)
    case welding         // Welding & hot work
    case transport       // Transport, lifting & handling
    case housekeeping    // Site housekeeping
    case cutting         // Cutting & fabrication
    case rebar           // Rebar & connections
    case concrete        // Concrete placement
    case demolition      // Demolition & dismantling
    case others          // Miscellaneous
}

extension WorkProcess {

    /// English title for UI
    var title: String {
        switch self {
        case .height:        return "Height"
        case .structure:     return "Structure"
        case .excavation:    return "Excavation"
        case .finishing:     return "Finishing"
        case .electrical:    return "Electrical"
        case .welding:       return "Welding"
        case .transport:     return "Transport"
        case .housekeeping:  return "Housekeeping"
        case .cutting:       return "Cutting"
        case .rebar:         return "Rebar"
        case .concrete:      return "Concrete"
        case .demolition:    return "Demolition"
        case .others:        return "Others"
        }
    }

    /// Checklist per process (fully in English, safety-focused wording)
    var checkList: [CheckListText] {
        switch self {

        // 1) Working at Height
        case .height:
            return [
                CheckListText(
                    title: "Scaffold Fall Protection",
                    content: "Platform structure verified, guardrails in place, safety nets installed."
                ),
                CheckListText(
                    title: "Steel Erection Fall Protection",
                    content: "Access ladders/stair towers provided, certified anchor points for harnesses, harness condition OK."
                ),
                CheckListText(
                    title: "Roof Work Fall Protection",
                    content: "Work platforms ≥ 300 mm wide, safety nets, and guardrails provided."
                ),
                CheckListText(
                    title: "Opening Protection",
                    content: "Floor/wall openings protected with guardrails, barricades, or load-rated covers."
                ),
                CheckListText(
                    title: "Scaffold Assembly Condition",
                    content: "No damaged planks, no loose joints/couplers, legs/plinths free of settlement or deformation."
                )
            ]

        // 2) Structure & Formwork
        case .structure:
            return [
                CheckListText(
                    title: "Earth-Retaining/Shoring Safety",
                    content: "Member connections and intersections secured; check for damage/corrosion; struts and walers installed."
                ),
                CheckListText(
                    title: "Formwork/Falsework Condition",
                    content: "Joints and connectors sound; verify bearing/soil; check for ground settlement."
                ),
                CheckListText(
                    title: "Timely Installation of Shoring",
                    content: "Supports installed concurrently with excavation as required."
                )
            ]

        // 3) Excavation & Earthwork
        case .excavation:
            return [
                CheckListText(
                    title: "Surrounding Ground Condition",
                    content: "Review topography, geology, groundwater level, and seepage conditions."
                ),
                CheckListText(
                    title: "Underground Utility Survey",
                    content: "Locate gas/water lines, power and telecom cables before excavation."
                ),
                CheckListText(
                    title: "Adequate Slope/Benching",
                    content: "Provide slopes/benching appropriate to soil conditions and surroundings."
                ),
                CheckListText(
                    title: "Slope/Embankment Control",
                    content: "Prevent collapse/rockfall; install drains/ditches; prevent soil run-off."
                ),
                CheckListText(
                    title: "Settlement & Crack Inspection",
                    content: "Daily patrol inspections; implement mitigation measures if issues found."
                )
            ]

        // 4) Others
        case .others:
            return [
                CheckListText(
                    title: "Roads & Drainage Around Site",
                    content: "Clear lane width and surface; remove unevenness/ice; provide traffic signage."
                ),
                CheckListText(
                    title: "Confined Space Work",
                    content: "Measure oxygen and toxic gases; ensure ventilation; assign an attendant."
                )
            ]

        // 5) Finishing & Painting
        case .finishing:
            return [
                CheckListText(
                    title: "Polyurethane Foam Work",
                    content: "Separate from hot work; provide ventilation and shielding; place fire extinguishers; post MSDS."
                )
            ]

        // 6) Mechanical & Electrical (temporary power, egress)
        case .electrical:
            return [
                CheckListText(
                    title: "Temporary Electrical Safety",
                    content: "Install ELCB/GFCI; use approved electrical equipment and cables correctly."
                ),
                CheckListText(
                    title: "Fire Alarm & Emergency Egress",
                    content: "Exit signage and lighting provided; alarm systems operational."
                )
            ]

        // 7) Welding & Repair (Hot Work)
        case .welding:
            return [
                CheckListText(
                    title: "Hot Work Safety (Pre/Post)",
                    content: "Check gas concentrations; segregate flammables; use spark/fire blankets; keep fire extinguishers nearby."
                ),
                CheckListText(
                    title: "Equipment Inspection",
                    content: "No cracked hoses; no gas leaks; flashback arrestors installed."
                )
            ]

        // 8) Transport & Handling
        case .transport:
            return [
                CheckListText(
                    title: "Tower Crane / Hoisting Operations",
                    content: "Suspend work in high winds; ensure supports/ties; secure and balance loads."
                ),
                CheckListText(
                    title: "Temporary Access Roads",
                    content: "Provide traffic signs; check steel road plates; ensure anti-slip measures."
                )
            ]

        // 9) Housekeeping
        case .housekeeping:
            return [
                CheckListText(
                    title: "General Housekeeping",
                    content: "Secure materials, tie down temporary items, and prevent debris dispersion."
                )
            ]

        // 10) Cutting & Fabrication
        case .cutting:
            return [
                CheckListText(
                    title: "Cutting/Hot Work Controls",
                    content: "Control flying sparks; keep fire extinguishers; shield adjacent combustibles."
                )
            ]

        // 11) Rebar & Connections
        case .rebar:
            return [
                CheckListText(
                    title: "Retaining Member Connections",
                    content: "Inspect for damage/deformation and corrosion at joints."
                ),
                CheckListText(
                    title: "Shoring/Bracing Installation",
                    content: "Verify connection integrity and proper tightening of struts/braces."
                )
            ]

        // 12) Concrete Placement
        case .concrete:
            return [
                CheckListText(
                    title: "Confined/Enclosed Areas During Curing",
                    content: "Provide ventilation for curing zones and assign an attendant as needed."
                ),
                CheckListText(
                    title: "Openings & Scaffold Safety During Pour",
                    content: "Fall protection in place; platforms inspected before and during placement."
                )
            ]

        // 13) Demolition & Dismantling
        case .demolition:
            return [
                CheckListText(
                    title: "Fall Protection During Dismantling",
                    content: "Maintain guardrails, safety nets, and lifeline anchorages during removal of temporary works."
                ),
                CheckListText(
                    title: "Equipment Work Plan",
                    content: "Plan excavator/dump operations; assign trained signalers/spotters."
                )
            ]
        }
    }
}
//
//import Foundation
//
//enum WorkProcess {
//    case highAltitudeAndAccess
//    case structureAndFormwork
//    case excavationAndEarthwork
//    case others
//    case finishingAndPainting
//    case mechanicalAndElectrical
//    case weldingAndRepair
//    case transportAndHandling
//    case housekeeping
//    case cuttingAndProcessing
//    case rebarAndConnection
//    case concretePlacement
//    case demolitionAndDismantling
//    
//    // 공공데이터로 가능하면 갱신
//    
//    var title: String {
//        switch self {
//        case .highAltitudeAndAccess:
//            return "고소, 접근"
//        case .structureAndFormwork:
//            return "골조, 거푸집"
//        case .excavationAndEarthwork:
//            return "굴착, 조성"
//        case .finishingAndPainting:
//            return "마감, 도장"
//        case .mechanicalAndElectrical:
//            return "설비, 전기"
//        case .weldingAndRepair:
//            return "용접, 보수"
//        case .transportAndHandling:
//            return "운반, 하역"
//        case .housekeeping:
//            return "정리"
//        case .cuttingAndProcessing:
//            return "절단, 가공"
//        case .rebarAndConnection:
//            return "철근, 연결"
//        case .concretePlacement:
//            return "콘크리트, 타설"
//        case .demolitionAndDismantling:
//            return "해체, 철거"
//        case .others:
//            return "기타"
//        }
//    }
//    
//    var checkList: [CheckListText] {
//        switch self {
//        case .highAltitudeAndAccess:
//            return [
//                CheckListText(title: "비계 상 추락방지", content: "작업발판 구조, 안전난간 설치 상태, 추락방호망 설치"),
//                CheckListText(title: "철골작업 시 추락방지", content: "승강로 설치, 안전대 부착설비, 안전대 이상유무"),
//                CheckListText(title: "지붕작업 시 추락방지", content: "폭 30cm 이상 발판, 추락방호망, 안전난간 설치"),
//                CheckListText(title: "개구부 추락방지", content: "안전난간, 울타리, 덮개 등 방호조치"),
//                CheckListText(title: "비계 조립상태", content: "발판재료 손상, 접속부 풀림, 비계기둥 변형·침하")
//            ]
//
//        case .structureAndFormwork:
//            return [
//                CheckListText(title: "흙막이 지보공 안전조치", content: "부재접합, 교차부, 손상·부식 점검, 버팀보·띠장 설치"),
//                CheckListText(title: "거푸집 동바리 등 가시설", content: "연결부·접속부 이상 유무, 지반 침하 여부"),
//                CheckListText(title: "지보공 적기 설치", content: "굴착과 동시에 설치 여부 확인")
//            ]
//
//        case .excavationAndEarthwork:
//            return [
//                CheckListText(title: "주변지반 이상유무", content: "지형·지질·지하수위·용수 상태 점검"),
//                CheckListText(title: "지하매설물 조사", content: "가스관, 상하수도관, 전기·통신케이블 위치 확인"),
//                CheckListText(title: "적정 굴착 기울기 확보", content: "지반조건·주변 여건 반영"),
//                CheckListText(title: "비탈면 관리", content: "붕괴·낙반 방지, 배수로 설치, 토사 유출 방지"),
//                CheckListText(title: "지반 침하·균열 점검", content: "매일 순회 점검, 대책 수립")
//            ]
//
//        case .others:
//            return [
//                CheckListText(title: "주변 도로 및 배수시설", content: "노면 폭·요철·결빙 제거, 안내 표지판 설치"),
//                CheckListText(title: "밀폐공간 작업", content: "산소·유해가스 측정, 환기, 감시인 배치")
//            ]
//
//        case .finishingAndPainting:
//            return [
//                CheckListText(title: "폴리우레탄폼 사용 작업", content: "화기사용 분리, 환기, 차폐시설, 소화기 비치, MSDS 설치")
//            ]
//
//        case .mechanicalAndElectrical:
//            return [
//                CheckListText(title: "가설전기", content: "누전차단기 설치 여부, 전기용품 적정 사용"),
//                CheckListText(title: "화재경보·비상탈출", content: "대피로 표지, 조명, 경보 설비")
//            ]
//
//        case .weldingAndRepair:
//            return [
//                CheckListText(title: "용접·용단 작업 전후 안전", content: "가스농도 측정, 인화성물질 격리, 불티 방지덮개, 소화기 비치"),
//                CheckListText(title: "장치 점검", content: "호스 균열, 가스누출 여부, 역화방지기 부착")
//            ]
//
//        case .transportAndHandling:
//            return [
//                CheckListText(title: "타워크레인 및 양중기", content: "강풍 시 작업제한, 지지 보강, 자재 결속"),
//                CheckListText(title: "가설도로", content: "교통 안내표지판, 복공판 상태, 미끄럼 방지")
//            ]
//
//        case .housekeeping:
//            return [
//                CheckListText(title: "현장 정리정돈(공종 공통)", content: "자재 고정, 가설물 결속, 비산 방지")
//            ]
//
//        case .cuttingAndProcessing:
//            return [
//                CheckListText(title: "용접·용단 안전조치", content: "불꽃·불티 비산 방지, 소화기 비치")
//            ]
//
//        case .rebarAndConnection:
//            return [
//                CheckListText(title: "흙막이 부재 접합부", content: "손상·변형, 부식 점검"),
//                CheckListText(title: "지보공·버팀보 설치", content: "결합상태 이상유무")
//            ]
//
//        case .concretePlacement:
//            return [
//                CheckListText(title: "밀폐공간 작업 고려", content: "양생구간 환기, 감시인 배치"),
//                CheckListText(title: "개구부·비계 안전관리", content: "타설 구간 추락방지, 발판 점검")
//            ]
//
//        case .demolitionAndDismantling:
//            return [
//                CheckListText(title: "가시설 해체 시 추락방지", content: "안전난간, 방호망, 안전대 부착설비 유지"),
//                CheckListText(title: "장비 작업계획", content: "굴삭기·덤프 등 해체장비 계획 및 유도자 배치")
//            ]
//        }
//    }
//}
//
//struct CheckListText {
//    var title: String
//    var content: String
//}
