export default function() {
  this.route("tl3", function() {
    this.route("actions", function() {
      this.route("show", { path: "/:id" });
    });
  });
};
