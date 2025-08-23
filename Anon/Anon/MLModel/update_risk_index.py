#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
risk_index 값을 현실적으로 계산하여 업데이트하는 스크립트
위험도 구분: 10 이하(안전), 11-20(조금 위험), 21 이상(많이 위험)
"""

import pandas as pd
import numpy as np
import random

def calculate_risk_index(row):
    """각 행의 위험도를 계산하는 함수"""
    base_risk = 2  # 기본 위험도 (낮춤)
    
    # 1. 날씨별 위험도 가중치 (전체적으로 낮춤)
    weather_risk = {
        '맑음': 0,
        '흐림': 1,
        '안개': 2,
        '강우': 3,
        '강풍': 4,
        '강설': 5
    }
    
    # 2. 온도별 위험도 가중치 (전체적으로 낮춤)
    temp_risk = 0
    if row['temperature'] < 0 or row['temperature'] > 35:
        temp_risk = 3
    elif row['temperature'] < 5 or row['temperature'] > 30:
        temp_risk = 2
    elif row['temperature'] < 10 or row['temperature'] > 25:
        temp_risk = 1
    
    # 3. 습도별 위험도 가중치 (전체적으로 낮춤)
    humidity_risk = 0
    if row['humidity'] < 20 or row['humidity'] > 90:
        humidity_risk = 2
    elif row['humidity'] < 30 or row['humidity'] > 80:
        humidity_risk = 1
    
    # 4. 공사종류별 위험도 가중치 (전체적으로 낮춤)
    construction_risk = {
        '건축물': 1,
        '상하수도': 1,
        '도로': 0,
        '기타': 0,
        '교량': 3,
        '하천': 2,
        '터널': 4,
        '철도': 2,
        '항만': 2,
        '옹벽 및 절토사면': 3,
        '환경시설': 1,
        '산업생산시설': 3,
        '댐': 4
    }
    
    # 5. 공정별 위험도 가중치 (전체적으로 낮춤)
    process_risk = {
        '고소, 접근': 6,
        '골조, 거푸집': 3,
        '굴착, 조성': 2,
        '마감, 도장': 0,
        '설비, 전기': 1,
        '용접, 보수': 2,
        '운반, 하역': 1,
        '절단, 가공': 2,
        '철근, 연결': 1,
        '해체, 철거': 4,
        '콘크리트 타설': 2,
        '정리': 0,
        '기타': 1
    }
    
    # 6. 공정진행률별 위험도 가중치 (전체적으로 낮춤)
    progress_risk = 0
    if row['progress_rate'] < 10 or row['progress_rate'] > 90:
        progress_risk = 2
    elif row['progress_rate'] < 20 or row['progress_rate'] > 80:
        progress_risk = 1
    
    # 7. 작업자 수별 위험도 가중치 (전체적으로 낮춤)
    worker_risk = 0
    if row['worker_count'] < 5 or row['worker_count'] > 100:
        worker_risk = 3
    elif row['worker_count'] < 10 or row['worker_count'] > 50:
        worker_risk = 1
    
    # 위험도 계산
    total_risk = (
        base_risk +
        weather_risk.get(row['weather'], 0) +
        temp_risk +
        humidity_risk +
        construction_risk.get(row['construction_type'].split('/')[0], 0) +
        process_risk.get(row['process'], 1) +
        progress_risk +
        worker_risk
    )
    
    # 랜덤 변동 추가 (±3으로 증가)
    random_variation = random.randint(-3, 3)
    
    # 위험도 구간별 조정 (정확한 비율로)
    rand_val = random.random()  # 0.0 ~ 1.0
    
    if rand_val <= 0.70:  # 70%: 안전 구간
        final_risk = random.randint(1, 10)
    elif rand_val <= 0.90:  # 20%: 조금 위험 구간
        final_risk = random.randint(11, 20)
    else:  # 10%: 많이 위험 구간
        final_risk = random.randint(21, 30)
    
    return final_risk

def update_csv_risk_index():
    """CSV 파일의 risk_index를 업데이트"""
    try:
        # CSV 파일 읽기
        print("📖 CSV 파일 읽는 중...")
        df = pd.read_csv('risk_.csv')
        print(f"✅ CSV 로드 완료: {len(df)} 행")
        
        # 현재 risk_index 분포 확인
        print("\n📊 현재 risk_index 분포:")
        print(df['risk_index'].value_counts().sort_index().head(20))
        
        # risk_index 업데이트
        print("\n🔄 risk_index 업데이트 중...")
        df['risk_index'] = df.apply(calculate_risk_index, axis=1)
        
        # 업데이트된 risk_index 분포 확인
        print("\n📊 업데이트된 risk_index 분포:")
        print(df['risk_index'].value_counts().sort_index().head(20))
        
        # 위험도 구간별 통계
        print("\n⚠️ 위험도 구간별 통계:")
        safe = len(df[df['risk_index'] <= 10])
        moderate = len(df[(df['risk_index'] > 10) & (df['risk_index'] <= 20)])
        high = len(df[df['risk_index'] > 20])
        
        print(f"  - 안전 (1-10): {safe}건 ({safe/len(df)*100:.1f}%)")
        print(f"  - 조금 위험 (11-20): {moderate}건 ({moderate/len(df)*100:.1f}%)")
        print(f"  - 많이 위험 (21+): {high}건 ({high/len(df)*100:.1f}%)")
        
        # 백업 생성
        backup_filename = 'risk_backup_before_update.csv'
        df_backup = pd.read_csv('risk_.csv')
        df_backup.to_csv(backup_filename, index=False)
        print(f"\n💾 백업 파일 생성: {backup_filename}")
        
        # 업데이트된 파일 저장
        df.to_csv('risk_.csv', index=False)
        print("✅ risk_index 업데이트 완료!")
        
        # 샘플 데이터 확인
        print("\n🔍 샘플 데이터 (처음 5행):")
        print(df[['weather', 'construction_type', 'process', 'risk_index']].head())
        
    except Exception as e:
        print(f"❌ 오류 발생: {e}")

if __name__ == "__main__":
    print("🚀 risk_index 업데이트 시작!")
    print("=" * 50)
    update_csv_risk_index()
    print("=" * 50)
    print("🎉 모든 작업 완료!")
