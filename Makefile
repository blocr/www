MD       := lcmark
CP       := rsync
MDFLAGS  := -u
CPFLAGS  := -avzq
BUILDDIR := public
TEMPLATE := template.html
FILTER   := filter.lua

PAGES    := $(patsubst %.md, $(BUILDDIR)/%.html, $(wildcard *.md))
POSTS    := $(patsubst posts/%.md, $(BUILDDIR)/posts/%.html, $(wildcard posts/*.md))
ASSETS   := $(patsubst assets/%, $(BUILDDIR)/assets/%, $(wildcard assets/**/*))

all: $(BUILDDIR) $(ASSETS) $(POSTS) $(PAGES)

$(BUILDDIR)/index.html: index.md $(TEMPLATE)
	$(MD) $(MDFLAGS) $< -T $(TEMPLATE) -F $(FILTER) > $@

$(BUILDDIR)/%.html: %.md $(TEMPLATE)
	$(MD) $(MDFLAGS) $< -T $(TEMPLATE) > $@

$(BUILDDIR)/posts/%.html: posts/%.md $(TEMPLATE)
	$(MD) $(MDFLAGS) $< -T $(TEMPLATE) > $@
	@touch -m index.md

$(BUILDDIR)/assets/%: assets/%
	$(CP) $(CPFLAGS) $< $@

$(BUILDDIR):
	mkdir -p $(BUILDDIR)/posts
	mkdir -p $(BUILDDIR)/assets/css
	mkdir -p $(BUILDDIR)/assets/js
	mkdir -p $(BUILDDIR)/assets/img
	mkdir -p $(BUILDDIR)/assets/keys

serve:
	python3 -m http.server -d $(BUILDDIR)

clean:
	rm -r $(BUILDDIR)
