import { keepPreviousData, useQuery } from "@tanstack/react-query";
import type { GetNutritionistsServicesSchema } from "@/schemas/nutritionistsServices/getNutritionistsServicesSchema";
import type { PaginationParamsSchema } from "@/schemas/paginationSchema";
import { parseQueryParams } from "@/utils/services";
import { ENV } from "@/utils/consts";

export interface NutritionistsServicesObj {
  id: number;
  nutritionist_id: number;
  service_id: number;
  created_at: string;
  updated_at: string;
  street: string;
  city: string;
  price: number;
  nutritionist: {
    id: number;
    name: string;
  };
  service: {
    name: string;
  };
}

export type GetNutritionistsServicesParams = GetNutritionistsServicesSchema &
  Partial<PaginationParamsSchema>;
export type GetNutritionistsServicesResponse = ApiGetListResponse<NutritionistsServicesObj[]> &
  Pagination;

export function getNutritionistsServices(params: GetNutritionistsServicesParams) {
  const queryParams = parseQueryParams(params);
  const queryString = new URLSearchParams(queryParams as Record<string, string>).toString();

  const url = new URL(ENV.VITE_API_URL + "nutritionists_services");
  url.search = queryString;

  return fetch(url);
}

export function useGetNutritionists(params: GetNutritionistsServicesParams) {
  return useQuery({
    queryKey: ["nutritionists_services", params],
    placeholderData: keepPreviousData,
    queryFn: async () => {
      const response = await getNutritionistsServices(params);
      return (await response.json()) as GetNutritionistsServicesResponse;
    },
  });
}
