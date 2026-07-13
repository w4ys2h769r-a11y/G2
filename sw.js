self.addEventListener('push', function(event) {
  let data = { title: 'G2 CONNECT', body: 'Nouvelle notification' };
  try {
    if (event.data) data = event.data.json();
  } catch (e) {}
  const title = data.title || 'G2 CONNECT';
  const isPanic = data.type === 'panic';
  // Motif de vibration long et saccadé façon sirène pour l'alerte panique,
  // motif court classique pour les consignes.
  const panicVibrate = [400, 150, 400, 150, 400, 150, 800, 150, 400, 150, 400, 150, 400];
  const options = {
    body: data.body || '',
    icon: '/G2/connexion-g2-background.png',
    badge: '/G2/connexion-g2-background.png',
    vibrate: isPanic ? panicVibrate : [200, 100, 200],
    tag: isPanic ? 'g2-panic-notification' : 'g2-connect-notification',
    renotify: true,
    requireInteraction: isPanic
  };
  event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener('notificationclick', function(event) {
  event.notification.close();
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function(clientList) {
      for (const client of clientList) {
        if (client.url.includes('/G2/') && 'focus' in client) return client.focus();
      }
      if (clients.openWindow) return clients.openWindow('/G2/');
    })
  );
});
