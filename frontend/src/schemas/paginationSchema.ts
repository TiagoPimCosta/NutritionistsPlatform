import { z } from "zod";

export const paginationParamsSchema = z.object({
  page: z.number().min(1).catch(1).optional(),
  per_page: z.number().min(1).catch(1).optional(),
});

export type PaginationParamsSchema = z.infer<typeof paginationParamsSchema>;
