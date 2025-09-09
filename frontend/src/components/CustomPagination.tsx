import {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from "./ui/pagination";

interface PaginationProps {
  currentPage: number;
  totalPages: number;
  onPageChange: (page: number) => void;
}

export default function CustomPagination(props: PaginationProps) {
  const { currentPage, totalPages, onPageChange } = props;

  const handleChangePage = (page: number) => {
    onPageChange(page);
  };

  const handlePreviousPage = () => {
    if (currentPage > 1) {
      handleChangePage(currentPage - 1);
    }
  };

  const handleNextPage = () => {
    if (currentPage < totalPages) {
      handleChangePage(currentPage + 1);
    }
  };

  return (
    <Pagination className="justify-start">
      <PaginationContent>
        <PaginationItem>
          <PaginationPrevious
            aria-disabled={currentPage <= 1}
            tabIndex={currentPage <= 1 ? -1 : 0}
            onClick={handlePreviousPage}
          />
        </PaginationItem>
        {Array.from({ length: totalPages }, (_, i) => {
          const pageIndex = i + 1;

          return (
            <PaginationItem key={pageIndex}>
              <PaginationLink
                isActive={currentPage === pageIndex}
                onClick={() => handleChangePage(pageIndex)}
              >
                {pageIndex}
              </PaginationLink>
            </PaginationItem>
          );
        })}
        <PaginationItem>
          <PaginationNext
            aria-disabled={currentPage >= totalPages}
            tabIndex={currentPage >= totalPages ? -1 : 0}
            onClick={handleNextPage}
          />
        </PaginationItem>
      </PaginationContent>
    </Pagination>
  );
}
