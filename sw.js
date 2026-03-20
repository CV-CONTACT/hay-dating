const CACHE = 'hay-dating-v4';

self.addEventListener('install', e => {
  self.skipWaiting();
  e.waitUntil(caches.keys().then(ns => Promise.all(ns.filter(n => n !== CACHE).map(n => caches.delete(n)))));
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(ns => Promise.all(ns.filter(n => n !== CACHE).map(n => caches.delete(n)))).then(() => clients.claim()));
});

self.addEventListener('fetch', e => {
  const url = e.request.url;
  if (url.includes('supabase.co') || url.includes('googleapis.com') || url.includes('gstatic.com') || url.includes('jsdelivr.net') || e.request.method !== 'GET') return;
  if (!url.startsWith(self.location.origin)) return;
  if (url.includes('.html') || url.endsWith('/')) {
    e.respondWith(fetch(e.request).then(r => { const c = r.clone(); caches.open(CACHE).then(ch => ch.put(e.request, c)); return r; }).catch(() => caches.match(e.request)));
  } else {
    e.respondWith(caches.match(e.request).then(r => r || fetch(e.request)));
  }
});
