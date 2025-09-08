import { Link } from "@tanstack/react-router";

export default function Header() {
  return (
    <header className="bg-header text-header-foreground">
      <div className="container mx-auto px-4 py-6">
        <div className="flex justify-between items-center">
          <Link className="flex items-center space-x-2" to="/">
            <img src="/nutrium-logo.png" alt="Nutrium Logo" className="h-8" />
          </Link>
          <div className="text-lg">
            Are you a nutrition professional? Get to know our software →
          </div>
        </div>
      </div>
    </header>
  );
}
