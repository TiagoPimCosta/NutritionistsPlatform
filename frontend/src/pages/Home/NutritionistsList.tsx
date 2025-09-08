import ProfessionalCard from "./ProfessionalCard";
import {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from "../../components/ui/pagination";

const nutritionProfessionals = [
  {
    id: "1",
    name: "Mary Jane",
    title: "Dietitian",
    credentials: "2963N",
    location: "Rua de Leiria",
    city: "Leiria",
    price: 25,
    followUp: true,
  },
  {
    id: "2",
    name: "Ana Silva",
    title: "Clinical Nutritionist",
    credentials: "3847N",
    location: "Avenida da Liberdade",
    city: "Lisboa",
    price: 35,
    followUp: false,
  },
  {
    id: "3",
    name: "João Santos",
    title: "Sports Nutritionist",
    credentials: "1925N",
    location: "Rua de Santa Catarina",
    city: "Porto",
    price: 40,
    followUp: true,
  },
  {
    id: "4",
    name: "Sofia Costa",
    title: "Pediatric Dietitian",
    credentials: "4562N",
    location: "Praça do Comércio",
    city: "Coimbra",
    price: 30,
    followUp: false,
  },
];

export default function NutritionistsList() {
  return (
    <div className="container mx-auto px-4 py-8 space-y-6">
      {nutritionProfessionals.map((professional) => (
        <ProfessionalCard key={professional.id} {...professional} />
      ))}

      <Pagination className="justify-start">
        <PaginationContent>
          <PaginationItem>
            <PaginationPrevious href="#" />
          </PaginationItem>
          <PaginationItem>
            <PaginationLink href="#" isActive>
              1
            </PaginationLink>
          </PaginationItem>
          <PaginationItem>
            <PaginationNext href="#" />
          </PaginationItem>
        </PaginationContent>
      </Pagination>
    </div>
  );
}
