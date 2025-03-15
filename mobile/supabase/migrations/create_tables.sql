-- 사용자 테이블 생성
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT NOT NULL UNIQUE,
  email TEXT NOT NULL UNIQUE,
  profile_image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  follower_count INTEGER DEFAULT 0 NOT NULL,
  following_count INTEGER DEFAULT 0 NOT NULL,
  is_deleted BOOLEAN DEFAULT FALSE NOT NULL
);

-- 사용자 팔로우 관계 테이블
CREATE TABLE IF NOT EXISTS public.follows (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  follower_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  following_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  UNIQUE(follower_id, following_id)
);

-- 사진 스팟 테이블
CREATE TABLE IF NOT EXISTS public.spots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  address TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  is_deleted BOOLEAN DEFAULT FALSE NOT NULL,
  view_count INTEGER DEFAULT 0 NOT NULL,
  like_count INTEGER DEFAULT 0 NOT NULL
);

-- 스팟 이미지 테이블
CREATE TABLE IF NOT EXISTS public.spot_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  spot_id UUID NOT NULL REFERENCES public.spots(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  is_main BOOLEAN DEFAULT FALSE NOT NULL
);

-- 스팟 좋아요 테이블
CREATE TABLE IF NOT EXISTS public.spot_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  spot_id UUID NOT NULL REFERENCES public.spots(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  UNIQUE(user_id, spot_id)
);

-- 스팟 댓글 테이블
CREATE TABLE IF NOT EXISTS public.spot_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  spot_id UUID NOT NULL REFERENCES public.spots(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  is_deleted BOOLEAN DEFAULT FALSE NOT NULL
);

-- 사용자 테이블에 RLS 정책 설정
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- 사용자 테이블 RLS 정책
CREATE POLICY "사용자는 자신의 프로필을 수정할 수 있습니다" ON public.users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "모든 사용자는 다른 사용자 프로필을 볼 수 있습니다" ON public.users
  FOR SELECT USING (true);

-- 팔로우 테이블에 RLS 정책 설정
ALTER TABLE public.follows ENABLE ROW LEVEL SECURITY;

-- 팔로우 테이블 RLS 정책
CREATE POLICY "사용자는 팔로우를 추가할 수 있습니다" ON public.follows
  FOR INSERT WITH CHECK (auth.uid() = follower_id);

CREATE POLICY "사용자는 자신의 팔로우를 삭제할 수 있습니다" ON public.follows
  FOR DELETE USING (auth.uid() = follower_id);

CREATE POLICY "모든 사용자는 팔로우 관계를 볼 수 있습니다" ON public.follows
  FOR SELECT USING (true);

-- 스팟 테이블에 RLS 정책 설정
ALTER TABLE public.spots ENABLE ROW LEVEL SECURITY;

-- 스팟 테이블 RLS 정책
CREATE POLICY "사용자는 스팟을 생성할 수 있습니다" ON public.spots
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "사용자는 자신의 스팟을 수정할 수 있습니다" ON public.spots
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "모든 사용자는 스팟을 볼 수 있습니다" ON public.spots
  FOR SELECT USING (true);

-- 스팟 이미지 테이블에 RLS 정책 설정
ALTER TABLE public.spot_images ENABLE ROW LEVEL SECURITY;

-- 스팟 이미지 테이블 RLS 정책
CREATE POLICY "사용자는 자신의 스팟에 이미지를 추가할 수 있습니다" ON public.spot_images
  FOR INSERT WITH CHECK (
    auth.uid() IN (
      SELECT user_id FROM public.spots WHERE id = spot_id
    )
  );

CREATE POLICY "사용자는 자신의 스팟 이미지를 수정할 수 있습니다" ON public.spot_images
  FOR UPDATE USING (
    auth.uid() IN (
      SELECT user_id FROM public.spots WHERE id = spot_id
    )
  );

CREATE POLICY "모든 사용자는 스팟 이미지를 볼 수 있습니다" ON public.spot_images
  FOR SELECT USING (true);

-- 스팟 좋아요 테이블에 RLS 정책 설정
ALTER TABLE public.spot_likes ENABLE ROW LEVEL SECURITY;

-- 스팟 좋아요 테이블 RLS 정책
CREATE POLICY "사용자는 스팟에 좋아요를 추가할 수 있습니다" ON public.spot_likes
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "사용자는 자신의 좋아요를 삭제할 수 있습니다" ON public.spot_likes
  FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "모든 사용자는 좋아요를 볼 수 있습니다" ON public.spot_likes
  FOR SELECT USING (true);

-- 스팟 댓글 테이블에 RLS 정책 설정
ALTER TABLE public.spot_comments ENABLE ROW LEVEL SECURITY;

-- 스팟 댓글 테이블 RLS 정책
CREATE POLICY "사용자는 스팟에 댓글을 추가할 수 있습니다" ON public.spot_comments
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "사용자는 자신의 댓글을 수정할 수 있습니다" ON public.spot_comments
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "모든 사용자는 댓글을 볼 수 있습니다" ON public.spot_comments
  FOR SELECT USING (true);

-- 트리거 함수: 팔로우 카운트 업데이트
CREATE OR REPLACE FUNCTION update_follow_counts()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.users SET follower_count = follower_count + 1 WHERE id = NEW.following_id;
    UPDATE public.users SET following_count = following_count + 1 WHERE id = NEW.follower_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.users SET follower_count = follower_count - 1 WHERE id = OLD.following_id;
    UPDATE public.users SET following_count = following_count - 1 WHERE id = OLD.follower_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 팔로우 트리거 생성
CREATE TRIGGER follow_counts_trigger
AFTER INSERT OR DELETE ON public.follows
FOR EACH ROW EXECUTE FUNCTION update_follow_counts();

-- 트리거 함수: 좋아요 카운트 업데이트
CREATE OR REPLACE FUNCTION update_like_counts()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.spots SET like_count = like_count + 1 WHERE id = NEW.spot_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.spots SET like_count = like_count - 1 WHERE id = OLD.spot_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 좋아요 트리거 생성
CREATE TRIGGER like_counts_trigger
AFTER INSERT OR DELETE ON public.spot_likes
FOR EACH ROW EXECUTE FUNCTION update_like_counts(); 