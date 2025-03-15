import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mobile/features/upload/view_models/upload_view_model.dart';

class UploadScreen extends HookConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadState = ref.watch(uploadViewModelProvider);
    final uploadViewModel = ref.watch(uploadViewModelProvider.notifier);

    // 단계 상태 관리 (0: 이미지 선택, 1: 상세 정보 입력)
    final currentStep = useState<int>(0);

    // 컨트롤러 생성
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final locationController = useTextEditingController();

    // 폼 키 생성
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // 이미지 상태 관리
    final selectedImage = useState<File?>(null);
    final isCropping = useState(false);

    // 태그 상태 관리
    final selectedTags = useState<List<String>>([]);

    // 사용 가능한 태그 목록
    final availableTags = [
      '야경',
      '카페',
      '한강',
      '전시회',
      '데이트',
      '벚꽃',
      '공원',
      '산책로',
      '역사',
      '궁궐',
      '바다',
      '산'
    ];

    // 이미지 크롭 함수
    Future<void> cropImage(File imageFile) async {
      isCropping.value = true;
      try {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          compressQuality: 90,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: '사진 자르기',
              toolbarColor: Theme.of(context).primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: '사진 자르기',
              doneButtonTitle: '완료',
              cancelButtonTitle: '취소',
              aspectRatioLockEnabled: false,
            ),
          ],
        );

        if (croppedFile != null) {
          selectedImage.value = File(croppedFile.path);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이미지 크롭 오류: $e')),
          );
        }
      } finally {
        isCropping.value = false;
      }
    }

    // 이미지 선택 함수
    Future<void> pickImage(ImageSource source) async {
      try {
        final picker = ImagePicker();
        final pickedImage = await picker.pickImage(
          source: source,
          maxWidth: 1800,
          maxHeight: 1800,
          imageQuality: 85,
        );

        if (pickedImage != null) {
          final imageFile = File(pickedImage.path);
          // 이미지 선택 후 크롭 화면으로 이동
          await cropImage(imageFile);
          // 크롭 완료 후 다음 단계로 이동
          if (selectedImage.value != null) {
            currentStep.value = 1;
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이미지 선택 오류: $e')),
          );
        }
      }
    }

    // 이미지 선택 다이얼로그
    void showImageSourceDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('사진 선택'),
          content: const Text('사진을 어디에서 가져올까요?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
              child: const Text('카메라'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
              child: const Text('갤러리'),
            ),
          ],
        ),
      );
    }

    // 태그 토글 함수
    void toggleTag(String tag) {
      final currentTags = List<String>.from(selectedTags.value);
      if (currentTags.contains(tag)) {
        currentTags.remove(tag);
      } else {
        currentTags.add(tag);
      }
      selectedTags.value = currentTags;
    }

    // 업로드 처리 함수
    Future<void> handleUpload() async {
      if (selectedImage.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사진을 선택해주세요')),
        );
        return;
      }

      if (formKey.currentState?.validate() ?? false) {
        try {
          await uploadViewModel.uploadPhoto(
            image: selectedImage.value!,
            title: titleController.text,
            description: descriptionController.text,
            location: locationController.text,
            tags: selectedTags.value,
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('사진이 업로드되었습니다')),
            );
            context.pop();
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('업로드 오류: $e')),
            );
          }
        }
      }
    }

    // 이미지 선택 화면
    Widget buildImageSelectionStep() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '사진을 선택해주세요',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: isCropping.value ? null : showImageSourceDialog,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: isCropping.value
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('이미지 크롭 중...'),
                          ],
                        ),
                      )
                    : selectedImage.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              selectedImage.value!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 64,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '사진을 선택해주세요',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
              ),
            ),
            const SizedBox(height: 24),
            if (selectedImage.value != null) ...[
              // 이미지 다시 크롭하기 버튼
              TextButton.icon(
                onPressed: isCropping.value
                    ? null
                    : () => cropImage(selectedImage.value!),
                icon: const Icon(Icons.crop),
                label: const Text('사진 다시 자르기'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    isCropping.value ? null : () => currentStep.value = 1,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('다음 단계로'),
              ),
            ],
          ],
        ),
      );
    }

    // 상세 정보 입력 화면
    Widget buildDetailInputStep() {
      return Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 선택한 이미지 미리보기
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: selectedImage.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          selectedImage.value!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(
                        child: Text('이미지가 선택되지 않았습니다'),
                      ),
              ),
              const SizedBox(height: 16),

              // 이미지 다시 선택 및 크롭 버튼
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: showImageSourceDialog,
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('사진 다시 선택하기'),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: selectedImage.value != null
                          ? () => cropImage(selectedImage.value!)
                          : null,
                      icon: const Icon(Icons.crop),
                      label: const Text('사진 자르기'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 제목 입력
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 위치 입력
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: '위치',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '위치를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 설명 입력
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: '설명',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '설명을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 태그 선택
              const Text(
                '태그 선택',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableTags.map((tag) {
                  final isSelected = selectedTags.value.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (_) => toggleTag(tag),
                    backgroundColor: Colors.grey[200],
                    selectedColor:
                        Theme.of(context).primaryColor.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // 업로드 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: uploadState.isLoading || isCropping.value
                      ? null
                      : handleUpload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: uploadState.isLoading || isCropping.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('업로드하기'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentStep.value == 0 ? '사진 선택' : '사진 업로드'),
        leading: currentStep.value == 0
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => currentStep.value = 0,
              ),
        actions: currentStep.value == 1
            ? [
                TextButton(
                  onPressed: uploadState.isLoading || isCropping.value
                      ? null
                      : handleUpload,
                  child: const Text('업로드'),
                ),
              ]
            : null,
      ),
      body: isCropping.value
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('이미지 크롭 중...'),
                ],
              ),
            )
          : currentStep.value == 0
              ? buildImageSelectionStep()
              : buildDetailInputStep(),
    );
  }
}
