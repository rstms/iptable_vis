# iptables-vis 


selected_chains = $(if $(CHAINS),-v chain_selector=$(CHAINS),)
empty_chains = $(if $(EMPTY),-v include_empty_chains=1,)

view: iptables.pdf
	gv $<

iptables.pdf: iptables.svg
	./svgtopdf $< $@

iptables.txt:
	sudo iptables -v -L | tr \" \' > $@

iptables.dia: iptables.txt
	awk -f iptables-vis.awk $(selected_chains) $(empty_chains)  <$< >$@

iptables.svg: iptables.dia
	blockdiag $< -T svg -o $@

clean:
	rm -f iptables.txt iptables.dia iptables.svg
