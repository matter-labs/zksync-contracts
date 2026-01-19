/**
 * Utility functions for JSON parsing in interop scripts
 */

/**
 * Pad a hex string to 66 characters (0x + 64 hex chars)
 * @param hex - Hex string starting with 0x
 * @returns Padded hex string
 */
export function padHex(hex: string): string {
  if (!hex.startsWith('0x')) return hex;
  if (hex.length >= 66) return hex;
  return '0x' + hex.slice(2).padStart(64, '0');
}

/**
 * Recursively walk through an object and apply a transformation to all string values
 * @param obj - Object to walk
 * @param transform - Function to apply to string values
 * @returns Transformed object
 */
export function walkAndTransform<T>(obj: T, transform: (val: string) => string): T {
  if (typeof obj === 'string') {
    return transform(obj) as T;
  }
  if (Array.isArray(obj)) {
    return obj.map(item => walkAndTransform(item, transform)) as T;
  }
  if (obj !== null && typeof obj === 'object') {
    const result: Record<string, unknown> = {};
    for (const [key, value] of Object.entries(obj)) {
      result[key] = walkAndTransform(value, transform);
    }
    return result as T;
  }
  return obj;
}

/**
 * Transform hex strings to be zero-padded to 64 hex chars
 * @param value - String value to potentially transform
 * @returns Transformed string
 */
export function padHexStrings(value: string): string {
  if (/^0x[0-9a-fA-F]+$/.test(value) && value.length < 66) {
    return padHex(value);
  }
  return value;
}

/**
 * Sort object keys alphabetically
 * @param obj - Object to sort
 * @returns Object with sorted keys
 */
export function sortObjectKeys<T extends Record<string, unknown>>(obj: T): T {
  const sorted: Record<string, unknown> = {};
  for (const key of Object.keys(obj).sort()) {
    sorted[key] = obj[key];
  }
  return sorted as T;
}
