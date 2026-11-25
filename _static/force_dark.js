/* The HORUS docs are dark only: ignore a stored light preference from another pydata site. */
document.documentElement.dataset.theme = "dark";
document.documentElement.dataset.mode = "dark";
try { localStorage.setItem("theme", "dark"); localStorage.setItem("mode", "dark"); } catch (e) {}
