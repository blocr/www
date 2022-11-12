MD         := pandoc
BUILDDIR   := public
TEMPLATES  := templates
FILTERS    := filters

PAGES      := $(patsubst %.md, $(BUILDDIR)/%.html, $(wildcard *.md))
POSTS      := $(patsubst posts/%.md, $(BUILDDIR)/posts/%.html, $(wildcard posts/*.md))
ASSETS     := $(patsubst assets/%, $(BUILDDIR)/assets/%, $(wildcard assets/**/*))
FEED       := $(BUILDDIR)/feed.xml

TIME       := $(shell date -u '+%b %d, %Y %H:%M:%S %Z')

all: $(BUILDDIR) $(ASSETS) $(POSTS) $(PAGES) $(FEED)

$(BUILDDIR)/index.html: index.md $(TEMPLATES)/page.html index.yml
	$(MD) $< --template $(TEMPLATES)/page -V time:'$(TIME)' --metadata-file index.yml -o $@

$(BUILDDIR)/%.html: %.md $(TEMPLATES)/page.html
	$(MD) $< --template $(TEMPLATES)/page -V time='$(TIME)' -o $@

$(BUILDDIR)/posts/%.html: posts/%.md $(TEMPLATES)/post.html
	$(MD) $< --template $(TEMPLATES)/post -V time='$(TIME)' -o $@

$(BUILDDIR)/assets/%: assets/%
	cp $< $@

$(FEED): index.yml $(TEMPLATES)/feed.xml
	$(MD) index.yml --template $(TEMPLATES)/feed.xml -V time:'$(shell date -u +'%FT%TZ')' -L $(FILTERS)/rfc3339.lua -o $@

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
