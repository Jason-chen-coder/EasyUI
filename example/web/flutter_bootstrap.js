{{flutter_js}}
{{flutter_build_config}}

const easySplash = document.getElementById('app_splash');
const removeEasySplash = () => {
  if (!easySplash) {
    return;
  }
  easySplash.classList.add('is-hidden');
  window.setTimeout(() => easySplash.remove(), 260);
};

window.addEventListener('flutter-first-frame', removeEasySplash, { once: true });

const easyLocalPreviewHosts = new Set(['localhost', '127.0.0.1', '::1']);
const isEasyLocalPreview = easyLocalPreviewHosts.has(window.location.hostname);
const easyServiceWorkerResetKey = 'easy_ui_sw_reset_once';
const easyBuildVersion =
  new URL(document.currentScript?.src ?? window.location.href).searchParams.get('v') ??
  '20260518-sponsor-nav';

const withEasyBuildVersion = (path) => {
  const separator = path.includes('?') ? '&' : '?';
  return `${path}${separator}v=${encodeURIComponent(easyBuildVersion)}`;
};

if (_flutter.buildConfig?.builds) {
  for (const build of _flutter.buildConfig.builds) {
    if (build.mainJsPath) {
      build.mainJsPath = withEasyBuildVersion(build.mainJsPath);
    }
  }
}

const clearLocalPreviewServiceWorkers = async () => {
  if (!isEasyLocalPreview || !('serviceWorker' in navigator)) {
    return false;
  }

  if ('caches' in window) {
    const cacheKeys = await caches.keys();
    await Promise.all(cacheKeys.map((cacheKey) => caches.delete(cacheKey)));
  }

  const registrations = await navigator.serviceWorker.getRegistrations();
  if (registrations.length === 0) {
    window.sessionStorage.removeItem(easyServiceWorkerResetKey);
    return false;
  }

  await Promise.all(
    registrations.map((registration) => registration.unregister()),
  );

  if (
    navigator.serviceWorker.controller &&
    window.sessionStorage.getItem(easyServiceWorkerResetKey) !== '1'
  ) {
    window.sessionStorage.setItem(easyServiceWorkerResetKey, '1');
    window.location.reload();
    return true;
  }

  window.sessionStorage.removeItem(easyServiceWorkerResetKey);
  return false;
};

const runEasyUi = async () => {
  const didReload = await clearLocalPreviewServiceWorkers().catch((error) => {
    console.warn('Failed to clear local preview service workers:', error);
    return false;
  });

  if (didReload) {
    return;
  }

  const loadOptions = {
    onEntrypointLoaded: async function(engineInitializer) {
      const appRunner = await engineInitializer.initializeEngine();
      await appRunner.runApp();
    },
  };

  _flutter.loader.load(loadOptions);
};

runEasyUi();
