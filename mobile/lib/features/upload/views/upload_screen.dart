import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/features/upload/view_models/upload_view_model.dart';

class UploadScreen extends HookConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadState = ref.watch(uploadViewModelProvider);
    final uploadViewModel = ref.watch(uploadViewModelProvider.notifier);

    // 컨트롤러 생성
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final locationController = useTextEditingController();

    // 폼 키 생성
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // 이미지 상태 관리
    final selectedImage = useState<File?>(null);

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
          selectedImage.value = File(pickedImage.path);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 업로드'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: uploadState.isLoading ? null : handleUpload,
            child: const Text('업로드'),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 선택 영역
              GestureDetector(
                onTap: showImageSourceDialog,
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: selectedImage.value != null
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
                              size: 48,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
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

              // 태그 입력
              const Text(
                '태그',
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
                        Theme.of(context).colorScheme.primaryContainer,
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                  );
                }).toList(),
              ),

              if (uploadState.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),

              if (uploadState.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SelectableText.rich(
                    TextSpan(
                      text: '오류: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: uploadState.error.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
