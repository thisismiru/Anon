//
//  WorkType.swift
//  Anon
//
//  Created by 김성현 on 2025-08-23.
//

enum WorkType: CaseIterable {
    case building
    case waterSupply
    case road
    case others
    case transportation
    case river
    case tunnel
    case railway
    case port
    case retainingStructure
    case environmentalFacility
    case industrialFacility
    case dam

    /// 한글 대분류명
    var largeWork: String {
        switch self {
        case .building: return "건축물"
        case .waterSupply: return "상하수도"
        case .road: return "도로"
        case .others: return "기타"
        case .transportation: return "교량"
        case .river: return "하천"
        case .tunnel: return "터널"
        case .railway: return "철도"
        case .port: return "항만"
        case .retainingStructure: return "옹벽 및 절토사면"
        case .environmentalFacility: return "환경시설"
        case .industrialFacility: return "산업생산시설"
        case .dam: return "댐"
        }
    }

    /// 중분류 리스트
    var mediumWork: [String] {
        switch self {
        case .building:
            return [
                "공동주택", "공장", "업무시설", "교육연구시설", "근린생활시설",
                "창고시설", "기타", "문화 및 집회시설", "숙박시설",
                "단독주택", "교정 및 군사시설", "운동시설"
            ]
        case .waterSupply:
            return ["하수도", "상수도", "기타"]
        case .road:
            return ["도로", "기타"]
        case .others:
            return ["부지조성", "간이배관"]
        case .transportation:
            return ["도로교량", "기타", "철도교량", "복개구조물"]
        case .river:
            return ["제방통관", "관거수로", "배수펌프장", "수문", "보"]
        case .tunnel:
            return ["철도터널", "도로터널", "기타", "지하차도"]
        case .railway:
            return ["지하철", "일반 및 고속철도", "기타"]
        case .port:
            return ["기타", "방파제", "계류시설", "호안", "갑문", "피사지"]
        case .retainingStructure:
            return ["옹벽", "절토사면", "기타"]
        case .environmentalFacility:
            return [
                "하수처리시설", "환경오염방지시설", "소각장",
                "수처리시험시설", "공공폐수처리시설", "중수도"
            ]
        case .industrialFacility:
            return ["석유화학공장", "제철공장"]
        case .dam:
            return ["용수전용댐", "기타", "다목적댐", "홍수전용댐"]
        }
    }
}
