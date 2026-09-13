// G2 CONNECT — fonction serveur d'envoi des notifications push
// À coller dans Supabase > Edge Functions > Create a new function
// Nom de la fonction : send-push

import webpush from "npm:web-push@3.6.7";

const VAPID_PUBLIC_KEY = Deno.env.get("VAPID_PUBLIC_KEY")!;
const VAPID_PRIVATE_KEY = Deno.env.get("VAPID_PRIVATE_KEY")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

webpush.setVapidDetails(
  "mailto:contact@g2connect.local",
  VAPID_PUBLIC_KEY,
  VAPID_PRIVATE_KEY
);

Deno.serve(async (req) => {
  try {
    const payload = await req.json();
    const table = payload.table;
    const record = payload.record || {};

    let title = "G2 CONNECT";
    let body = "Nouvelle notification";
    let targetAgentId: string | null = null;
    let type = "consigne";

    if (table === "consignes") {
      title = record.type === "générale"
        ? "📋 Nouvelle consigne collective"
        : "📋 Nouvelle consigne individuelle";
      body = record.titre || "Consultez l'application G2 Connect";
      if (record.type === "individuelle") targetAgentId = record.agentId;
      type = "consigne";
    } else if (table === "panic_events") {
      title = "🚨 ALERTE URGENTE";
      body = (record.name || "Un agent") + " a déclenché une alerte";
      type = "panic";
    } else {
      return new Response(JSON.stringify({ skipped: true }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    let url = `${SUPABASE_URL}/rest/v1/push_subscriptions?select=*`;
    if (targetAgentId) url += `&agentId=eq.${encodeURIComponent(targetAgentId)}`;

    const res = await fetch(url, {
      headers: {
        apikey: SERVICE_ROLE_KEY,
        Authorization: `Bearer ${SERVICE_ROLE_KEY}`,
      },
    });
    const subs = await res.json();

    // Pour le badge sur l'icône : nombre de consignes non lues par agent destinataire.
    let consignesList: any[] = [];
    if (type === "consigne") {
      const cRes = await fetch(
        `${SUPABASE_URL}/rest/v1/consignes?select=type,agentId,lus,dateExpiration`,
        {
          headers: {
            apikey: SERVICE_ROLE_KEY,
            Authorization: `Bearer ${SERVICE_ROLE_KEY}`,
          },
        }
      );
      consignesList = await cRes.json();
    }
    const now = new Date();
    function unreadCountFor(agentId: string): number {
      return (consignesList || []).filter((c: any) => {
        if (c.dateExpiration && new Date(c.dateExpiration) < now) return false;
        const relevant =
          c.type === "générale" ||
          (c.type === "individuelle" && String(c.agentId) === String(agentId));
        if (!relevant) return false;
        return !(c.lus && c.lus[agentId]);
      }).length;
    }

    const results = await Promise.allSettled(
      (subs || []).map((s: any) => {
        const badgeCount = type === "consigne" ? unreadCountFor(s.agentId) : undefined;
        return webpush.sendNotification(
          { endpoint: s.endpoint, keys: { p256dh: s.p256dh, auth: s.auth } },
          JSON.stringify({ title, body, type, badgeCount })
        );
      })
    );

    return new Response(
      JSON.stringify({ sent: results.length }),
      { headers: { "Content-Type": "application/json" } }
    );
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
