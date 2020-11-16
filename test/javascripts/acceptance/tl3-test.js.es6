import { acceptance } from "discourse/tests/helpers/qunit-helpers";

acceptance("tl3", { loggedIn: true });

test("tl3 works", async assert => {
  await visit("/admin/plugins/tl3");

  assert.ok(false, "it shows the tl3 button");
});
