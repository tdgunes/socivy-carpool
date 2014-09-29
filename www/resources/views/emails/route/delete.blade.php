<pre>
Merhaba {{{ $userName  }}};

{{{ $routeOwnerName }}} adlı kişi sizin katılacağınız rotayı silmiştir.

Silinen rotaya ait bilgiler:
Yön: @Lang('route.plan.' . $routePlan)

Saat: {{{ $routeActionTime }}}
Rotanın uğrayacağı yerler:
@foreach($routePlaces as $routePlace)
    - {{{ $routePlace['name'] }}}
@endforeach
</pre>