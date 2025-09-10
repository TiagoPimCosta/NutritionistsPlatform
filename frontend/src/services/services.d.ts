interface ApiResponseError<T> {
  message: string;
  errors?: Record<keyof T, string[]>;
}

interface ApiGetListResponse<T> {
  items?: T;
}

interface Pagination {
  page: number;
  per_page: number;
  total_count: number;
  total_pages: number;
}

interface ApiResponseMessage {
  message: string;
}
