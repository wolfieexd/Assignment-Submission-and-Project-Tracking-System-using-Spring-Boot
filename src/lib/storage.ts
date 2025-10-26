// Small wrapper for localStorage with namespacing and safe access.
const PREFIX = "app:";

function prefixed(key: string) {
  return `${PREFIX}${key}`;
}

export function setItem(key: string, value: string) {
  try {
    localStorage.setItem(prefixed(key), value);
  } catch (e) {
    // ignore storage errors (e.g., quota exceeded or disabled)
    // Optionally, add logging or telemetry here.
  }
}

export function getItem(key: string): string | null {
  try {
    return localStorage.getItem(prefixed(key));
  } catch (e) {
    return null;
  }
}

export function removeItem(key: string) {
  try {
    localStorage.removeItem(prefixed(key));
  } catch (e) {
    // ignore
  }
}

export function clearAppStorage() {
  try {
    const keys: string[] = [];
    for (let i = 0; i < localStorage.length; i++) {
      const k = localStorage.key(i);
      if (k && k.startsWith(PREFIX)) keys.push(k);
    }
    for (const k of keys) localStorage.removeItem(k);
  } catch (e) {
    // ignore
  }
}

export default { setItem, getItem, removeItem, clearAppStorage };
