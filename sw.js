const CACHE_NAME = 'CosmicCorner';
const urlsToCache = [
  './',
  './index.html',
  './manifest.json'
];

// Install the service worker
self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(function(cache) {
        console.log('Opened cache');
        return cache.addAll(urlsToCache);
      })
  );
});

// Fetch resources
self.addEventListener('fetch', function(event) {
  event.respondWith(
    caches.match(event.request)
      .then(function(response) {
        // Return cached response if found, else fetch from network
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
