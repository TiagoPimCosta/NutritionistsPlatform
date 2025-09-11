import { Outlet, createRootRouteWithContext } from "@tanstack/react-router";
import { ToastContainer } from "react-toastify";
import Header from "../components/Header";
import type { QueryClient } from "@tanstack/react-query";

interface MyRouterContext {
  queryClient: QueryClient;
}

export const Route = createRootRouteWithContext<MyRouterContext>()({
  component: () => (
    <>
      <ToastContainer
        position="top-right"
        autoClose={3000}
        stacked={true}
        className="text-xs font-bold text-black"
      />
      <Header />
      <Outlet />
    </>
  ),
});
