import coremltools as ct

# 모델 로드
model = ct.models.MLModel('Anon/MLModel/ANON.mlmodel')

# 모델 정보 출력
print("=== ANON 모델 정보 ===")
print(f"모델 타입: {type(model)}")
print(f"모델 설명: {model.get_spec().description}")

# 입력 피처 정보
print("\n=== 입력 피처 ===")
for feature in model.get_spec().description.input:
    print(f"- {feature.name}: {feature.type}")

# 출력 피처 정보
print("\n=== 출력 피처 ===")
for feature in model.get_spec().description.output:
    print(f"- {feature.name}: {feature.type}")

# 모델 메타데이터
print("\n=== 모델 메타데이터 ===")
metadata = model.get_spec().description.metadata
for key, value in metadata.user_defined.items():
    print(f"- {key}: {value}")
