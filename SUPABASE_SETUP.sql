-- ============================================
-- Hay Dating v2 — SQL for Supabase
-- Run in: Supabase > SQL Editor > New Query
-- ============================================

-- IMPORTANT: If old tables exist, drop them first:
-- DROP TABLE IF EXISTS messages CASCADE;
-- DROP TABLE IF EXISTS matches CASCADE;
-- DROP TABLE IF EXISTS likes CASCADE;
-- DROP TABLE IF EXISTS profiles CASCADE;

CREATE TABLE IF NOT EXISTS profiles (
  id bigint generated always as identity primary key,
  name text not null,
  password text not null,
  age integer default 25,
  gender text default 'male',
  city text default 'Ереван',
  bio text default '',
  interests text default '',
  photos text default '',
  last_seen timestamptz default now(),
  created_at timestamptz default now()
);

CREATE TABLE IF NOT EXISTS likes (
  id bigint generated always as identity primary key,
  from_user bigint not null references profiles(id),
  to_user bigint not null references profiles(id),
  created_at timestamptz default now(),
  unique(from_user, to_user)
);

CREATE TABLE IF NOT EXISTS matches (
  id bigint generated always as identity primary key,
  user1 bigint not null references profiles(id),
  user2 bigint not null references profiles(id),
  created_at timestamptz default now()
);

CREATE TABLE IF NOT EXISTS messages (
  id bigint generated always as identity primary key,
  match_id bigint not null references matches(id),
  sender_id bigint not null references profiles(id),
  text text not null,
  created_at timestamptz default now()
);

-- RLS policies (open for demo)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "profiles_all" ON profiles FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "likes_all" ON likes FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "matches_all" ON matches FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "messages_all" ON messages FOR ALL USING (true) WITH CHECK (true);

-- Test profiles
INSERT INTO profiles (name, password, age, gender, city, bio, interests) VALUES
  ('Մariam', 'test123', 24, 'female', 'Ереван', 'Обожаю путешествия и хорошую музыку. Ищу интересного собеседника', 'Музыка,Путешествия,Кино,Йога'),
  ('Ալinа', 'test123', 27, 'female', 'Ереван', 'Фотограф и кофеман. Люблю закаты и горы Армении', 'Фото,Искусство,Кофе,Горы'),
  ('Իnessa', 'test123', 23, 'female', 'Гюмri', 'Студентка, танцую и готовлю. Верю в добрых людей', 'Танцы,Кулинария,Книги,Природа'),
  ('Давид', 'test123', 29, 'male', 'Ереван', 'Программист, играю на гитаре. Люблю IT и горы', 'IT,Гитара,Спорт,Кино'),
  ('Артур', 'test123', 31, 'male', 'Ереван', 'Предприниматель. Обожаю вино и горные походы', 'Бизнес,Горы,Вино,Книги'),
  ('Гор', 'test123', 26, 'male', 'Ванадзор', 'Дизайнер, фанат кино и новых технологий', 'Дизайн,Кино,Путешествия,Музыка');
