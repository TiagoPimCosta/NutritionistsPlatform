import { toastError } from "@/utils/toasts";
import { QueryClient } from "@tanstack/react-query";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
      retry: false,
    },
    mutations: {
      onError: (error) => {
        if (error.name === "TypeError") {
          toastError("An unkown error occured. Please try again or contact support.");
        }
        return error;
      },
    },
  },
});

export default queryClient;
