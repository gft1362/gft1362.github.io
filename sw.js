/* Service Worker — پلتفرم ژنوم
 * استراتژی: cache-first برای فایل‌های استاتیک، network-first برای بقیه
 * نسخه ۱
 */
const CACHE='genome-v1';
const STATIC_ASSETS=[
  './',
  './index.html',
  './genome.html',
  './privacy.html',
  './questionnaire.html',
  './result.html',
  './manifest.json',
  './robots.txt'
];

self.addEventListener('install',e=>{
  e.waitUntil(
    caches.open(CACHE).then(c=>c.addAll(STATIC_ASSETS).catch(()=>{}))
      .then(()=>self.skipWaiting())
  );
});

self.addEventListener('activate',e=>{
  e.waitUntil(
    caches.keys().then(keys=>Promise.all(
      keys.filter(k=>k!==CACHE).map(k=>caches.delete(k))
    )).then(()=>self.clients.claim())
  );
});

self.addEventListener('fetch',e=>{
  const req=e.request;
  // فقط GET
  if(req.method!=='GET')return;
  // فقط همان مبدا
  const url=new URL(req.url);
  if(url.origin!==location.origin)return;

  // strategy: network-first, fallback to cache
  e.respondWith(
    fetch(req).then(res=>{
      // cache a copy
      const clone=res.clone();
      caches.open(CACHE).then(c=>c.put(req,clone)).catch(()=>{});
      return res;
    }).catch(()=>{
      // fallback
      return caches.match(req).then(cached=>cached||caches.match('./index.html'));
    })
  );
});
