export function parseQueryParams<T extends Record<string, string | number | boolean>>(
  params: T
): T {
  return Object.entries(params).reduce<T>((acc, [key, value]) => {
    if (value !== undefined && value !== null) {
      acc[key as keyof T] = value as T[keyof T];
    }
    return acc;
  }, {} as T);
}
