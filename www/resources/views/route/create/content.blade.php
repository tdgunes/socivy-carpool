<div class="row">
    <div class="col-md-12 col-xs-12 map-area">
        <div id="map">

        </div>

        <div class="point-popup" style="display: none;">
            <div class="row">
                <div class="col-xs-9">
                    <input class="point-name form-control" type="text"/>
                </div>
                <div class="col-xs-3">
                    <button type="submit" class="btn btn-danger delete-popup">Sil</button>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-6 col-md-offset-3 col-xs-12 form-area">
        <div class="row">

            <form class="form-horizontal" role="form">

                <div class="form-group">
                    <label for="input-description" class="col-xs-2 control-label">Plan</label>
                    <div class="col-xs-10">
                        <div class="radio-inline">
                            <label for="plan-from-school">
                                <input id="plan-from-school" name="plan" value="fromSchool" type="radio"/> ÖzÜ'den Durağa
                            </label>
                        </div>

                        <div class="radio-inline">
                            <label for="plan-to-school">
                                <input id="plan-to-school" name="plan" value="toSchool" type="radio"/> Duraktan ÖzÜ'ye
                            </label>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="input-description" class="col-xs-2 control-label">Bilgi</label>
                    <div class="col-xs-10">
                        <textarea id="description" cols="30" rows="10" class="form-control"></textarea>
                    </div>
                </div>
                
            </form>
        </div>
    </div>
</div>