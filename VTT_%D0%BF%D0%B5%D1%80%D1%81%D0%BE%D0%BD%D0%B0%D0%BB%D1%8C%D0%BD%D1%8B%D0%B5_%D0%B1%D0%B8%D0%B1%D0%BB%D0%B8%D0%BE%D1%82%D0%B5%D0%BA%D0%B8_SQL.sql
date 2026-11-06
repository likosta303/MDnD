-- VTT: персональные библиотеки аккаунтов.
-- Безопасная идемпотентная миграция: существующие таблицы и записи не удаляются.

ALTER TABLE public.vtt_characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vtt_creatures ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vtt_mechanics_settings ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.vtt_characters FROM anon, PUBLIC;
REVOKE ALL ON TABLE public.vtt_creatures FROM anon, PUBLIC;
REVOKE ALL ON TABLE public.vtt_mechanics_settings FROM anon, PUBLIC;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.vtt_characters TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.vtt_creatures TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.vtt_mechanics_settings TO authenticated;

DROP POLICY IF EXISTS "characters own all" ON public.vtt_characters;
CREATE POLICY "characters own all"
ON public.vtt_characters
FOR ALL TO authenticated
USING (owner_id = (SELECT auth.uid()))
WITH CHECK (owner_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS "creatures own all" ON public.vtt_creatures;
CREATE POLICY "creatures own all"
ON public.vtt_creatures
FOR ALL TO authenticated
USING (owner_id = (SELECT auth.uid()))
WITH CHECK (owner_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS "mechanics settings own all" ON public.vtt_mechanics_settings;
CREATE POLICY "mechanics settings own all"
ON public.vtt_mechanics_settings
FOR ALL TO authenticated
USING (user_id = (SELECT auth.uid()))
WITH CHECK (user_id = (SELECT auth.uid()));

NOTIFY pgrst, 'reload schema';
