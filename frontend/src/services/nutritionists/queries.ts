import { keepPreviousData, useQuery } from "@tanstack/react-query";
import type { GetNutritionistsSchema } from "@/schemas/nutritionists/getNutritionistsSchema";
import type { PaginationParamsSchema } from "@/schemas/paginationSchema";
import { parseQueryParams } from "@/utils/services";

export interface NutritionistObj {
  id: number;
  name: string;
  street: string;
  city: string;
  price: number;
  services: [
    {
      name: string;
    },
    {
      name: string;
    },
  ];
}
export type GetNutritionistsParams = GetNutritionistsSchema & Partial<PaginationParamsSchema>;
export type GetLinesResponse = ApiGetListResponse<NutritionistObj[]> & Pagination;

export function getNutritionists(params: GetNutritionistsParams) {
  const queryParams = parseQueryParams(params);
  const queryString = new URLSearchParams(queryParams as Record<string, string>).toString();

  const url = new URL("http://localhost:3000/nutritionists");
  url.search = queryString;

  return fetch(url);
}

export function useGetNutritionists(params: GetNutritionistsParams) {
  return useQuery({
    queryKey: ["nutritionists", params],
    placeholderData: keepPreviousData,
    queryFn: async () => {
      const response = await getNutritionists(params);
      return (await response.json()) as GetLinesResponse;
    },
  });
}
