// Exemplo ilustrativo de Edge Function. Configure o provedor de e-mail e os secrets
// antes de usar. Não inclua chaves privadas no HTML ou no repositório.
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async (_req) => {
  // Recomendação: use uma integração server-side autenticada/trigger de banco
  // para invocar esta função; não aceite destinatário ou conteúdo arbitrário do visitante.
  const emailApiKey = Deno.env.get("EMAIL_PROVIDER_API_KEY");
  const notifyTo = Deno.env.get("OUVIDORIA_NOTIFY_TO");
  if (!emailApiKey || !notifyTo) {
    return new Response("Notificação não configurada", { status: 503 });
  }
  // Adapte ao provedor escolhido e envie apenas aviso mínimo, sem relato sensível.
  return new Response("Configure a integração do provedor de e-mail antes de ativar.", { status: 501 });
});
